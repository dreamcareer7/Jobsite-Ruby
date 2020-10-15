class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Localise::UserCity
  include Localise::UserCoordinates
  include Localise::UserDistance
  include Localise::UserLanguage
  before_action :current_language
  before_action :current_city
  before_action :current_coordinates

  helper_method :distance
  helper_method :distance_to_s

  include Pundit
  include HandleLoginRedirect

  before_action :current_business
  before_action :limit_business_page_views

  helper_method :page_title
  helper_method :after_sign_in_path_for
  helper_method :default_profile
  helper_method :text_direction
  helper_method :nav_modifier
  helper_method :current_country
  helper_method :current_country_cities

  VISITOR_VIEW_LIMIT = 3

  private

  def authenticate_admin_or_user!
    return true if admin_signed_in?
    authenticate_user!
  end

  def after_sign_in_path_for(resource)
    if cookies[:loginTarget].present? && !resource.is_a?(Admin)
      #concern: handle_login_redirect
      return handle_login_target(resource)
    end

    case resource
      when Admin then admin_overview_index_path
      #concern: handle_login_redirect
      when User then default_profile(resource)
    end
  end

  def after_invite_path_for(*)
    admin_admins_path
  end

  def current_business
    if session[:business_id].present?
      begin
        @current_business ||= Business.find(session[:business_id])
      rescue ActiveRecord::RecordNotFound
        session.delete(:business_id)
      end
    else
      current_user.present? &&
        current_user.businesses.present? ?
        @current_business ||= current_user.businesses.first :
        return
    end
  end

  def text_direction
    I18n.locale == :en ? "ltr" : "rtl"
  end
 
  def page_title
    if controller_name == "categories" 
      listing_type = "#{ I18n.t("words.categories") }"
      if @category
        listing_type = @category.name
      end
      title_modifier = "#{ listing_type } #{ I18n.t("words.in") } #{ current_city.name.titleize }"
    elsif controller_name == "sub_categories"
      listing_type =   "#{ I18n.t("words.sub_categories") }"
      if @sub_category
        listing_type = @sub_category.name
      end
      title_modifier = "#{ listing_type } #{ I18n.t("words.in") } #{ current_city.name.titleize }"
    elsif controller_name == "services"
      listing_type = "#{ I18n.t("words.services") }"
      if @service
        listing_type = @service.name
      end
      title_modifier = "#{ listing_type } #{ I18n.t("words.in") } #{ current_city.name.titleize }"
    elsif controller_name == "businesses"
      listing_type = "#{ I18n.t("words.businesses") }"
      if @business && !@business.new_record?
        listing_type = @business.name
      end
      title_modifier = "#{ listing_type.capitalize } #{ I18n.t("words.in") } #{ current_city.name.titleize }"
    elsif controller_name == 'home' && current_city
      title_modifier = "#{ I18n.t("phrases.contractors_suppliers")} #{ I18n.t("words.in") } #{ current_city.name }, #{ current_city.country.name }"
    else
      title_modifier = controller_name.capitalize
    end

    "#{ title_modifier.present? ? title_modifier + ' | ' : '' }#{ I18n.t("words.muqawiloon")}"
  end

  def nav_modifier
    return unless controller_path == "home" || controller_path.split("/").shift == "business"
    controller_path == "home" ? '' : 'primary-nav--dashboard'
    # controller_path == "home" ? 'primary-nav--transparent' : 'primary-nav--dashboard'
  end

  def limit_business_page_views
    #business#show has content_for :page_scripts to check if value is true and pops modal accordingly
    return unless controller_path == "businesses" && current_user.blank?

    if cookies.signed[:view_count].present? && cookies.signed[:view_count] >= VISITOR_VIEW_LIMIT
      @suggest_signup = true
      cookies.signed[:view_count] = 0
    end

    return cookies.signed[:view_count] += 1 if cookies[:view_count].present?

    cookies.signed[:view_count] = {
      value: 1,
      expires: 24.hours.from_now
    }
  end

  def after_sign_out_path_for(resource_or_scope)
    return new_admin_session_path if resource_or_scope == :admin

    root_path
  end

end
