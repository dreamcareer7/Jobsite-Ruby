module SortInbox
  extend ActiveSupport::Concern

  def handle_sorting(messages, filter_term)

    case filter_term

    when "Projectmessages"
      @inbox =  @project_correspondence
    when "Othermessages"
      @inbox = @conversations
    when "Callbackrequests"
      @inbox = @notifications.by_type("callback request").order(created_at: :desc)
    else
      @inbox.sort_by!(&:created_at).reverse!
    end

  end

end
