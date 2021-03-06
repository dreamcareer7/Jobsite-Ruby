class HomeController < ApplicationController
  include SetupTrendingSection

  before_action :check_path_contains_city

  def index
    @current_city= City.first
    @categories = Category.order(created_at: :asc)
    @popular_sub_categories = SubCategory.visible.includes(:category_metadata).popular_by_listing_count(@current_city).first(4)
    @specialist = Category.where(name: "Specialists").first
    @city_image = @current_city.city_image ? @current_city.city_image : ''

    setup_trending_section
  end

  private

  def check_path_contains_city
    return if params[:city].present?
    redirect_to "/#{I18n.with_locale(:en){ @current_city.name } }" if @current_city
  end

end
