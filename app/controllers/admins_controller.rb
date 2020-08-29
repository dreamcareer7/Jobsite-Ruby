class AdminsController < ApplicationController

  def accept_business_claim
    notification = Notification.find(params[:notification_id])
    business = Business.find(notification.business_id)

    business.update_columns(user_id: notification.sending_user_id)
    business.set_status
  end

  def send_user_password_reset
    User.find(params[:user_id]).send_reset_password_instructions
  end

end

