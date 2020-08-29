module FilterCities
  extend ActiveSupport::Concern

  def filter_cities
    @cities = Country.where(id: params[:country_for_select]).map(&:cities).reduce(:+)

    respond_to do |format|
      format.js
    end
  end

end
