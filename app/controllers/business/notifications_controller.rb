class Business::NotificationsController < Business::BaseController
  include TimeHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  after_action :verify_policy_scoped, only: [:index?, :show?]

  def new
    @notification = current_business.outgoing_notifications.new
  end

  def create
    authorize Notification

    params[:notification][:receiving_user_type] = "User"

    @notification = current_business.outgoing_notifications.create(notification_params)

    if @notification.save
      redirect_back(fallback_location: business_profile_index_path) 
      flash[:notice] = "Message sent."
    else
      redirect_back(fallback_location: business_profile_index_path) 
      flash[:error] = "The message could not be sent. Try again later."
    end
  end

  def show
    authorize Notification

    @notification = Notification.find(params[:id])

    @notification.mark_as_read
  end

  def mark_as_read
    @notification = Notification.find(params[:notification][:value])
    @notification.mark_as_read
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :receiving_user_id, :receiving_user_type)
  end

  def policy(record)
    Business::MessagePolicy.new(current_business, record)
  end

  def user_not_authorised
    redirect_back(fallback_location: business_profile_index_path)
    flash[:error] = "Your business has been disabled"
  end

end
