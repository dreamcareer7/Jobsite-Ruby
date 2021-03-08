class HomeController < ApplicationController
  include SetupTrendingSection

  before_action :check_path_contains_city

  def index
    
    @categories = CachedItems.all_categories
    @popular_sub_categories = CachedItems.popular_items(@current_city)
    my_sp = Category.where(:name=> "Specialists").first
    @specialist_cached_services =my_sp.services.visible.shuffle.first(16).in_groups_of(4)
    @city_image = @current_city.city_image ? @current_city.city_image : ''
    #@specialist_cached_services =CachedItems.cached_sp_services(@specialist)
    setup_trending_section
  end

  private

  def check_path_contains_city
    return if params[:city].present?
    redirect_to "/#{I18n.with_locale(:en){ @current_city.name } }" if @current_city
  end

end
