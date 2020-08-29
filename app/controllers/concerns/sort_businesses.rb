module SortBusinesses
  extend ActiveSupport::Concern

  def handle_sorting(businesses, filter_terms)

    case filter_terms 

    when "Latest"
      @businesses = businesses.latest.distinct
    when "Recommended"
      paid = businesses.paid.by_profile_completion
      verified = businesses.verified.by_profile_completion
      unverified = businesses.unverified.by_profile_completion
      @businesses = (paid + verified + unverified).uniq
    when "Verified"
      @businesses = businesses.verified.by_profile_completion.distinct
    when "Distance"
      return unless @current_coordinates.present?

      @businesses = businesses.includes(:locations).distinct.sort_by do |business|
        business.distance_from_user(@current_city, @current_coordinates)
      end

    else
      @businesses = Kaminari.paginate_array(businesses).page(params[:page]).per(6)
    end

  end

end
