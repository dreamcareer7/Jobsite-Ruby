module FormatNotificationBodyHelper

  def format_notification_body(notification)
    case notification.notification_type

    when "callback request"
      message_body = {
        blurb: " callback requested at "
      }
    when "active"
      message_body = {
        blurb: " quote accepted for "
      }
    when "review"
      message_body = {
        blurb: " reviewed "
      }
    when "invited"
      message_body = {
        blurb: " invited to "
      }
    when "quote"
      message_body = {
        blurb: " new quote "
      }
    when "not chosen"
      message_body = {
        blurb: " You were not chosen for project "
      }
    when "shortlisted"
      message_body = {
        blurb: " shortlisted for project "
      }
    when "pending completion"
      message_body = {
        blurb: " marked as complete  "
      }
    when "confirm completion"
      message_body = {
        blurb: " confirmed as complete  "
      }
    when "deny completion"
      message_body = {
        blurb: " completion denied  "
      }
    when "project cancelled"
      message_body = {
        blurb: " work has been cancelled  "
      }
    when "applied to project"
      message_body = {
        blurb: " applied to project  "
      }
    when "not interested"
      message_body = {
        blurb: " no longer interested in project  "
      }
    else
      message_body = {
        blurb: ""
      }
    end
  end


end
