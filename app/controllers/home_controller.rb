class HomeController < ApplicationController
  include SetupTrendingSection

  before_action :check_path_contains_city

  def index
    #@current_city= City.first
    @categories = CachedItems.all_categories
    @popular_sub_categories = CachedItems.popular_items(@current_city)
    @specialist = Category.where(name: "Specialists").first
    @specialist_cached_services =CachedItems.cached_sp_services(@specialist)
    @city_image = @current_city.city_image ? @current_city.city_image : ''

    setup_trending_section
  end

  private

  def check_path_contains_city
    return if params[:city].present?
    redirect_to "/#{I18n.with_locale(:en){ @current_city.name } }" if @current_city
  end

end
