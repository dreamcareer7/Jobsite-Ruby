class User::InboxController < User::BaseController
  #TODO refactor
  include InboxLinkPathHelper
  include SortInbox

  def index
    @notifications = current_user.incoming_notifications
    @other_notifications = @notifications.where(project_id: nil)
    @project_notifications = @notifications.order(created_at: :desc).select(&:project_id).uniq(&:project_id)
    @projects = current_user.projects

    @project_messages = @projects.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:project_id).uniq(&:project_id)

    @project_correspondence = [ @project_messages, @project_notifications ].flatten.sort_by{ |pc| pc.created_at }.reverse!.select(&:project_id).uniq(&:project_id)

    @conversations = current_user.conversations.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:conversation_id).uniq(&:conversation_id)


    @inbox = @project_correspondence + @other_notifications + @conversations

    @project_notification_types = ["shortlisted", "active", "completed", "invited", "applied"]
    @filter_terms = ["All messages", "Project messages", "Other messages"]

    if params[:filter_by].present?
      @inbox = handle_sorting(@inbox, params[:filter_by]) || [] # or empty array to handle no results
      @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
    else
      @inbox.sort_by!(&:created_at).reverse!
      @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
    end

  end

end

