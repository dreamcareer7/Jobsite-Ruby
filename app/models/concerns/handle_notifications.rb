module HandleNotifications
  extend ActiveSupport::Concern

  def send_callback_request(callback)
    user = User.find(callback.user_id)
    business = Business.find(callback.business_id)
    number = callback.user_number

    @notification = Notification.create(
      body: "#{ number }",
      notification_type: "callback request",
      sending_user_id: user.id, 
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_quote_request(quote_request)
    @notification = Notification.create(
      project_id: quote_request.project.id,
        quote_id: quote_request.id,
        notification_type: "invited",
        sending_user_id: quote_request.user.id, 
        sending_user_type: "User",
        receiving_user_id: quote_request.business.id,
        receiving_user_type: "Business")
  end

  def send_applied_to_project(project, business)
    @notification = Notification.create(
      notification_type: "applied to project",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: business.id,
      sending_user_type: "Business",
      receiving_user_id: project.user.id,
      receiving_user_type: "User")
  end

  def send_not_chosen(project, business)

    @notification = Notification.create(
      notification_type: "not chosen",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id, 
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_shortlisted(project, business)

    @notification = Notification.create(
      notification_type: "shortlisted",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id, 
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_rejected(project, business)

    @notification = Notification.create(
      notification_type: "rejected",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id, 
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_quote(quote, project, business)

    @notification = Notification.create(
      notification_type: "quote",
      quote_id: quote.id,
      project_id: project.id,
      business_id: business.id,
      sending_user_id: business.id, 
      sending_user_type: "Business",
      receiving_user_id: project.user.id,
      receiving_user_type: "User")
  end

  def send_accepted(project, business)

    @notification = Notification.create(
      notification_type: "active",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id, 
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_pending_completion(project, business)
    @notification = Notification.create(
      notification_type: "pending completion",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: business.id,
      sending_user_type: "Business",
      receiving_user_id: project.user.id,
      receiving_user_type: "User")
  end

  def send_confirm_completion(project, business)
    @notification = Notification.create(
      notification_type: "confirm completion",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id,
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_deny_pending_completion(project, business)
    @notification = Notification.create(
      notification_type: "deny completion",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id,
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_review(review, project, business)
    @notification = Notification.create(
      notification_type: "review",
      project_id: project.id,
      sending_user_id: review.user_id, 
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_business_hidden_by_user(project, business)
    @notification = Notification.create(
      notification_type: "not interested",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id,
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

  def send_project_hidden_by_business(project, business)
    @notification = Notification.create(
      notification_type: "not interested",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: business.id,
      sending_user_type: "Business",
      receiving_user_id: project.user.id,
      receiving_user_type: "User")
  end

  def send_project_cancelled_by_business(project, business)
    @notification = Notification.create(
      notification_type: "project cancelled",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: business.id,
      sending_user_type: "Business",
      receiving_user_id: project.user.id,
      receiving_user_type: "User")
  end

  def send_project_cancelled_by_user(project, business)
    @notification = Notification.create(
      notification_type: "project cancelled",
      project_id: project.id,
      business_id: business.id,
      sending_user_id: project.user.id,
      sending_user_type: "User",
      receiving_user_id: business.id,
      receiving_user_type: "Business")
  end

end
