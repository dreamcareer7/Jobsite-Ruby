module InboxLinkPathHelper
  include NamespaceHelper

  def get_path_for(entry)

    if entry.is_a?(Notification) && entry.notification_type == "callback request"
      return business_notification_path(entry) if current_namespace == "business"
      return user_notification_path(entry) if current_namespace == "user"

    elsif entry.is_a?(Notification) && entry.notification_type == "review"
      return business_reviews_path if current_namespace == "business"
      return user_reviews if current_namespace == "user"

    elsif entry.is_a?(Notification) && entry.notification_type == "quote" || entry.is_a?(Notification) && entry.notification_type == "pending completion"
      return user_project_project_business_path(entry.project_id, entry.business_id) if current_namespace == "user"

    elsif entry.is_a?(Notification) && entry.project_id.present?
      return business_project_feed_path(entry.project_id) if current_namespace == "business"
      return user_project_path(entry.project_id) if current_namespace == "user"

    elsif entry.is_a?(Message) && entry.project_id.present?
      return business_project_feed_path(entry.project_id) if current_namespace == "business"

      if entry.sending_user_type == "Business"
        return user_project_project_business_path(entry.project_id, entry.sending_user_id)
      elsif entry.sending_user_type == "User"
        return user_project_project_business_path(entry.project_id, entry.receiving_user_id)
      end

    elsif entry.is_a?(Message)
      return business_message_path(entry) if current_namespace == "business"
      return user_message_path(entry) if current_namespace == "user"

    else
      return business_inbox_index_path if current_namespace == "business"
      return user_inbox_index_path if current_namespace == "user"

    end

  end

end
