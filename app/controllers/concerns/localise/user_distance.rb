module Localise::UserDistance
  extend ActiveSupport::Concern
  #https://gist.github.com/j05h/673425

  def distance(location_one, location_two)
    location_one_array = location_one.is_a?(Array) ? location_one : coords_to_array(location_one)
    location_two_array = location_two.is_a?(Array) ? location_two : coords_to_array(location_two)

    lat_one, lon_one = location_one_array
    lat_two, lon_two = location_two_array

    distance_lat = to_rad((lat_two - lat_one))
    distance_lon = to_rad((lon_two - lon_one))

    haversine = Math.sin(distance_lat/2) * Math.sin(distance_lat/2) +
      Math.cos(to_rad(lat_one)) * Math.cos(to_rad(lat_two)) *
      Math.sin(distance_lon/2) * Math.sin(distance_lon/2)

    difference = 2 * Math.atan2(Math.sqrt(haversine), Math.sqrt(1-haversine))

    6371 * difference #km
  end

  def distance_to_s(location_one, location_two)
    distance = distance(location_one, location_two)

    distance.round(2)
  end

  private

  def to_rad(coords)
    coords * Math::PI / 180
  end

  def coords_to_array(coords)
    coords = coords.split(/[,!]/)

    [coords[0].to_f, coords[1].to_f]
  end

end
