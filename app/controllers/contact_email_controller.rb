class ContactEmailController < ApplicationController

  def create
    @contact_email = ContactEmail.new(contact_email_params)

    @contact_email.recipient = choose_recipient

    #valid instead of save because not saving in db
    if @contact_email.valid?
      ContactFormMailer.new_email(@contact_email).deliver
      send_admin_notification

      redirect_back(fallback_location: root_path)
      flash[:notice] = "Message sent"
    else
      redirect_back(fallback_location: root_path)
      flash[:error] = "Message could not be sent"
    end
  end

  def choose_recipient
    case @contact_email.subject_target
    when "job"
      'careers@muqawiloon.com, info@muqawiloon.com'
    when "business", "advertise"
      'sales@muqawiloon.com, info@muqawiloon.com'
    when "general", "other"
      'info@muqawiloon.com'
    when "claim"
      'admin@muqawiloon.com, sales@muqawiloon.com, info@muqawiloon.com'
    end
  end

  def send_admin_notification
    AdminNotification.inquiry_notification(@contact_email)
  end

  private

  def contact_email_params
    params.require(:contact_email).permit(:from, :name, :subject, :body, :subject_target, :number)
  end
end
