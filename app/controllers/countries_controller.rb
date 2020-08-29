class CountriesController < ApplicationController
  include Localise::UserCity

  def index
    @countries = Country.enabled.includes(:translations, cities: :translations)

    if current_user
      current_user.update_attributes(browse_location: @current_city.id)
    end

  end

end
