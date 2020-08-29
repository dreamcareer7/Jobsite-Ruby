class User::ProfileController < User::BaseController
  include SetupTrendingSection

  def index
    @messages = current_user.incoming_messages.order(created_at: :desc)
    @conversations = current_user.conversations.includes(:messages).collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:conversation_id).uniq(&:conversation_id)
    @notifications = current_user.incoming_notifications.order(updated_at: :desc).first(3)

    @dashboard_banners = Banner.relevant_banner("dashboard banner", @current_city.country)

    @projects = current_user.projects.order(created_at: :desc).first(3)

    session[:dashboard] = user_profile_index_path

    setup_trending_section
  end

end
