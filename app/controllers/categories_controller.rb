class CategoriesController < ApplicationController
  include SortBusinesses
  include QuoteButtonHelper
  include Listing::Banners
  include Listing::Filter
  include Listing::Business

  before_action :set_category, only: [:show]
  before_action :set_filter_terms, only: [:show]
  before_action :set_quote_button, only: [:show]
  before_action :set_banners, only: [:show]

  after_action :record_listed_businesses, only: [:show]

  def index
    @categories = Category.includes(:category_metadata, :translations, sub_categories: :category_metadata ).order('sub_categories.name asc')
  end

  def show
    @sub_categories = @category.sub_categories.includes(:category_metadata).visible.enabled.order(name: :asc)
    @trending_sub_categories = @sub_categories.trending.limit(3)

    @unpaginated_businesses = (
      Business
      .active
      .includes(:locations)
      .by_city(@current_city)
      .by_category(@category)
      .distinct
    )

    @featured_businesses = get_featured_businesses(@unpaginated_businesses)
    @businesses = handle_filter(@unpaginated_businesses)
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])

    if request.path != category_path(id: @category.slug)
      return redirect_to category_path(id: @category.slug), status: :moved_permanently
    end
  end

  def set_banners
    banners(@category)
  end

  def set_quote_button
    @quote_button = appropriate_button(@category)
  end

  def record_listed_businesses
    return if @businesses.blank?

    RecordListedBusinessesJob.perform_later(@businesses)
  end

end
