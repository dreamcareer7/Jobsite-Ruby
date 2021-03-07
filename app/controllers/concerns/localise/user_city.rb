module Localise::UserCity
  extend ActiveSupport::Concern

  def current_city
    return @current_city if @current_city

    # check path and if no cookie set cookie
    @current_city = get_city_from_path unless controller_path.starts_with?('admin/cities')

    if @current_city
      set_city_cookie(@current_city) unless cookies.signed[:city]
      return @current_city
    end

    # check for cookie
    @current_city = get_city_cookie
    return @current_city if @current_city

    # if admin or test, use first city if no other city available
    return @current_city = City.first if Rails.env.test? || controller_path.starts_with?('admin') || controller_name == "passwords"

    # force city selection if city is invalid
    redirect_to cities_path(protocol: :https) and return
  end

  def set_city_cookie(city)
    cookies.permanent.signed[:city] = city.id
  end

  private

  def get_city_cookie
    return false unless cookies.signed[:city].present?

    begin city = City.unscoped.find(cookies.signed[:city])
      return city if city.enabled?
      # remove cookie if city is disabled
      delete_city_cookie
    rescue ActiveRecord::RecordNotFound
      # remove cookie if city does not exist
      delete_city_cookie
    end

    # if city in cookie is invalid
    return false
  end

  def get_city_from_path

   
    return false unless params[:city].present?

    begin city = CachedItems.get_cached_city(params[:city])
      return city if city && city.enabled?

    rescue ActiveRecord::RecordNotFound
      return false
    end
    # if city in path is invalid
    return false
  end

  def delete_city_cookie
    cookies.delete :city
  end


end
