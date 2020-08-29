class User::NotificationsController < User::BaseController
  include HandleConversations

  def index
    @incoming_notifications = current_user.incoming_notifications.by_type(params[:filter_by])
    @outgoing_notifications = current_user.outgoing_notifications
  end

  def new
    @notification = current_user.outgoing_notifications.new
    @notification_type = params[:notification_type].present? ? params[:notification_type] : ""
    @business = Business.friendly.find(params[:business_id]) if params[:business_id].present?
  end

  def create
    if session[:target_business].present?
      params[:notification][:receiving_user_type] = "Business"
      params[:notification][:receiving_user_id] = session[:target_business]
      session.delete(:target_business)
    end

    if session[:receiver_type].present?
      params[:notification][:receiving_user_type] = session[:receiver_type]
    end

    @notification = current_user.outgoing_notifications.create(notification_params)

    if @notification.save
      redirect_back(fallback_location: user_profile_index_path)
      flash[:notice] = "Message sent."
    else
      redirect_back(fallback_location: user_profile_index_path)
      flash[:error] = "We couldn't send your message. Try again later."
    end
  end

  def show
    @notification = Notification.find(params[:id])
    @quote = Quote.find(@notification.quote_id) if @notification.quote_id.present?
    @conversation = find_conversation(@notification.sender, @notification.receiver)
    session[:receiver_type] = @notification.receiving_user_type

    @notification.mark_as_read
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :receiving_user_id, :receiving_user_type, :notification_type)
  end

end
