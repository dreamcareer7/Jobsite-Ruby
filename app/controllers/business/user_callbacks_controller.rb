class Business::UserCallbacksController < Business::BaseController

  respond_to :json

  def new
  end

  def create
    params[:user_callback] = {} if params[:user_callback].blank?
    params[:user_callback][:user_id] = current_user.id
    params[:user_callback][:business_id] = session[:target_business]
    params[:user_callback][:user_number] = current_user.mobile_number if current_user.mobile_number.present?
    params[:user_callback][:user_number] = params[:new_user_number] if params[:new_user_number].present?

    @user_callback = UserCallback.create(user_callback_params)

    if @user_callback.save
      Notification.send_callback_request(@user_callback)
      AdminNotification.new_callback_request_notification(@user_callback.user, @user_callback.business)
      redirect_back(fallback_location: root_path)
      session.delete(:callback_business)
      flash[:notice] = "Callback request submitted."
    else
      redirect_back(fallback_location: root_path)
      flash[:error] = "We couldn't submit the callback request at this time."
    end

  end

  private

  def user_callback_params
    params.require(:user_callback).permit(:user_id, :business_id, :user_number)
  end

end
