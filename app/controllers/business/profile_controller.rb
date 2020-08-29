class Business::ProfileController < Business::BaseController
  before_action :set_business
  include FormatNotificationBodyHelper

  def index
    redirect_back(fallback_location: user_profile_index_path) unless policy_scope(@business)

    @services = @business.services
    @projects = Project.by_city(@current_city).by_services(@services).not_completed_or_accepted.order(created_at: :desc).group(:id).first(2)
    @messages = @business.incoming_messages.order(updated_at: :desc).first(2)
    @notifications = @business.incoming_notifications.order(updated_at: :desc).first(3)

    @profile_views = @business.impressionist_count(message: "profile_view", filter: :all)
    @website_visits = @business.impressionist_count(message: "website_view", filter: :all)
    @social_media_visits = @business.impressionist_count(message: "social_view", filter: :all)
    @phone_number_reveals = @business.impressionist_count(message: "number_view", filter: :all)

    @stats = {
      profile_views: @profile_views,
      website_views: @website_visits,
      social_media_visits: @social_media_visits,
      phone_number_reveals: @phone_number_reveals
    }

    @dashboard_banners = Banner.relevant_banner("dashboard banner", @current_city.country)

    session[:dashboard] = business_profile_index_path(@business)
  end

  private

  def set_business
    @business = @current_business.present? ? @current_business : current_user.businesses.first
  end

end
