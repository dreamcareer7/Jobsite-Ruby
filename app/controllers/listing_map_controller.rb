class ListingMapController < ApplicationController
  include Listing::Business

  before_action :set_category, only: :index
  before_action :set_sub_category, only: :index
  before_action :set_service, only: :index

  def index
    @businesses = Business.where(id: params[:businesses])
    @featured_businesses = get_featured_businesses(@businesses)
    @markers = create_markers_for_locations

    @listing_type = get_listing_type
    @listing_path = request.referrer


    @map_city = @current_city

    if @listing_type.is_a?(Category)
      @trending_sub_categories = @listing_type.sub_categories.trending.first(3)
    elsif @listing_type.is_a?(SubCategory)
      @listing_banner = @listing_type.metadata_banner
      @trending_sub_categories = @listing_type.category.sub_categories.trending.first(3)
    elsif @listing_type.is_a?(Service)
      @listing_banner = @listing_type.sub_category.metadata_banner
      @trending_sub_categories = @listing_type.category.sub_categories.trending.first(3)
    end
  end

  def get_listing_type
    return @service if @service.present?
    return @sub_category if @sub_category.present?
    return @category if @category.present?
  end

  def create_markers_for_locations
    locations = @businesses.map do |business| 
      next if !business.is_a?(Business)

      business.try(:locations).by_city(@current_city)
    end

    Gmaps4rails.build_markers(locations) do |location, marker|
      next if location.latitude.blank? || location.longitude.blank?

      marker.lat location.latitude
      marker.lng location.longitude
      marker.json data: { business: "#{ location.owner.id }" }
      marker.infowindow render_to_string(partial: "/partials/maps/info_window", locals: { location: location })
    end
  end

  private

  def set_category
    return unless params[:category].present?

    begin
      @category = Category.friendly.find(params[:category])
    rescue ActiveRecord::RecordNotFound
      return redirect_to root_path, status: 410
    end
  end

  def set_sub_category
    return unless params[:sub_category].present?

    begin
      @sub_category = SubCategory.friendly.find(params[:sub_category])
    rescue ActiveRecord::RecordNotFound
      return redirect_to root_path, status: 410
    end
  end

  def set_service
    return unless params[:service].present?

    begin
      @service = Service.friendly.find(params[:service])
    rescue ActiveRecord::RecordNotFound
      return redirect_to root_path, status: 410
    end
  end

end
