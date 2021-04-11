class ServicesController < ApplicationController
  include SortBusinesses
  include QuoteButtonHelper
  include Listing::Banners
  include Listing::Filter
  include Listing::Business

  impressionist actions: [:show]

  before_action :set_service, only: [:show]
  before_action :set_category, only: [:show]
  before_action :set_sub_category, only: [:show]
  before_action :set_filter_terms, only: [:show]
  before_action :set_quote_button, only: [:show]
  before_action :set_banners, only: [:show]

  after_action :record_listed_businesses, only: [:show]
  after_action :update_view_count, only: [:show]

  def show
    category_sub_categories = @category.cached_subcategories_enabled
    @trending_sub_categories = category_sub_categories.trending.first(3)

    #always place current sub category first
    @sub_categories = (category_sub_categories
      .to_a
      .rotate!(category_sub_categories.to_a.index(@sub_category)))

    @unpaginated_businesses = (Business
      .active
      .for_listing
      .by_city(@current_city)
      .by_service(@service)
      .distinct)

    @featured_businesses = get_featured_businesses(@unpaginated_businesses)
    @businesses = handle_filter(@unpaginated_businesses)
  end

  private

  def set_service
    begin
      @service = Service.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return redirect_to root_path, status: 410
    end

    return redirect_to root_path, status: 410 if @service.hidden

    if request.path != service_path(id: @service.slug)
      return redirect_to service_path(id: @service.slug), status: :moved_permanently
    end
  end

  def set_sub_category
    @sub_category = @service.sub_category
  end

  def set_category
    @category = @service.category
  end

  def set_banners
    banners(@sub_category)
  end

  def set_quote_button
    @quote_button = appropriate_button(@category)
  end

  def record_listed_businesses
    return if @businesses.blank?

    RecordListedBusinessesJob.perform_later(@businesses)
  end

  def update_view_count
    CacheViewCountJob.perform_later(@service)
    CacheViewCountChangeJob.perform_later(@service)
  end
end
