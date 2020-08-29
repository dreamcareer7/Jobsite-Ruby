class LocationsController < ApplicationController

  def filter_cities
    @cities = Country.find(params[:country_for_select]).cities
    @target_element = params[:target_element]

    render template: "partials/location/filter_cities"
  end

end
