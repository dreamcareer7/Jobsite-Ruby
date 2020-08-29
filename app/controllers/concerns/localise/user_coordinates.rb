module Localise::UserCoordinates
  extend ActiveSupport::Concern

  JEDDAH_IP = "213.5.172.167"
  JEDDAH_GEOCODE_RESULT = {
    data: {
      "ip"=>"213.5.172.167",
      "city"=>"Jeddah",
      "region"=>"Makkah Province",
      "country"=>"SA",
      "latitude"=>21.5169,
      "longitude"=>39.2192
    }
  }

  def current_coordinates
    return @current_coordinates if @current_coordinates

    @current_coordinates = get_browser_coordinates_cookie
    return @current_coordinates if @current_coordinates

    @current_coordinates = get_ip_coordinates_cookie
    return @current_coordinates if @current_coordinates

    # geocode user ip if browser coords not accessible
    @current_coordinates = geocode_ip(remote_ip)
  end

  private

  def get_browser_coordinates_cookie
    coords = cookies[:browserCoords]

    return false if coords == 'declined' || coords.blank?

    return join_coordinates(coords)
  end

  def get_ip_coordinates_cookie
    coords = cookies.signed[:ipCoords]

    return false if coords.blank?

    return join_coordinates(coords)
  end

  def geocode_ip(ip)
    geocoded = Geocoder.search(remote_ip)

    if geocoded.blank?
      # fall back to Jeddah if IP location is invalid
      geocoded = OpenStruct.new JEDDAH_GEOCODE_RESULT
      # place in array so we can handle same way as normal result
      geocoded = [geocoded]
    end

    coordinates = extract_ip_coordinates(geocoded)

    cookies.permanent.signed[:ipCoords] = coordinates

    join_coordinates(coordinates)
  end

  def remote_ip
    # get real IP from CloudFare
    return request.env['HTTP_CF_CONNECTING_IP'] if request.env['HTTP_CF_CONNECTING_IP'].present?

    # use Jeddah-based IP for local dev and nil IP
    return JEDDAH_IP if request.remote_ip.nil? ||
      request.remote_ip.empty? ||
      request.remote_ip.starts_with?('127', '10', '192.168')


    request.remote_ip
  end

  def extract_ip_coordinates(location)
    geo_ip = location.first.data

    "#{ geo_ip["latitude"] }!#{ geo_ip["longitude"] }"
  end

  def join_coordinates(location)
    location.split("!").join(",")
  end

end
