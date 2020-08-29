class AdminNotificationsController < ApplicationController

  def create
    @notification = AdminNotification.create(admin_notification_params)

    if @notification.save
      #remove redirect param from URL
      redirect_to request.referer.split('?').first
      flash[:notice] = "Request sent"
    else
      redirect_back(fallback_location: root_path)
      flash[:error] = @notification.errors.full_messages
    end

  end

  private

  def admin_notification_params
    params.require(:admin_notification).permit(:notification_type, :content, :page_link, :user_id, :business_id, :resolved, :user_number, :project)
  end

end
