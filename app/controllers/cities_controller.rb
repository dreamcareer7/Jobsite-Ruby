class CitiesController < ApplicationController
  include Localise::UserCity

  skip_before_action :current_city

  layout "no_layout_layout"

  def index
    @countries = Country.enabled.includes(:translations, cities: :translations)
  end

  def choose_city
    cookies.delete :city if cookies[:city].present?

    city = City.friendly.find(params[:city_id])

    set_city_cookie(city)

    if current_user
      current_user.update(browse_location: city.id)
    end

    redirect_to root_path
  end

end
