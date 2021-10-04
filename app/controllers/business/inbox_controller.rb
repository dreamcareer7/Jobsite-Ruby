class Business::InboxController < Business::BaseController
  include InboxLinkPathHelper
  include SortInbox

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  after_action :verify_policy_scoped, only: :index?

  def index
    authorize Notification

    @notifications = @current_business.incoming_notifications
    @other_notifications = @notifications.where(project_id: nil)
    @project_notifications = @notifications.order(created_at: :desc).select(&:project_id).uniq(&:project_id)
    @projects = Project.where(id: @project_notifications.pluck(:project_id))

    @project_messages = @projects.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:project_id).uniq(&:project_id)

    @project_correspondence = [ @project_messages, @project_notifications ].flatten.sort_by{ |pc| pc.created_at }.reverse!.select(&:project_id).uniq(&:project_id)

    @conversations = @current_business.conversations.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:conversation_id).uniq(&:conversation_id)

    @inbox = @project_correspondence + @other_notifications + @conversations

    @project_notification_types = ["shortlisted", "active", "completed", "invited", "applied"]
    @filter_terms = ["All messages", "Project messages", "Other messages", "Callback requests"]

    if params[:filter_by].present?
      @inbox = handle_sorting(@inbox, params[:filter_by]) || [] # or empty array to handle no results
      @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
    else
      @inbox.sort_by!(&:created_at).reverse!
      @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
    end

    @reviews = Kaminari.paginate_array(current_user.reviews.order(created_at: :desc)).page(params[:page]).per(6)

  end

  private

  def policy(record)
    Business::InboxPolicy.new(current_business, record)
  end

  def user_not_authorised
    redirect_back(fallback_location: business_profile_index_path)
    flash[:error] = "Your business has been disabled"
  end

end
