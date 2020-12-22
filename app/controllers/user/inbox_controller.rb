class User::InboxController < User::BaseController
  #TODO refactor
  include InboxLinkPathHelper
  include SortInbox

  # def index
  #   @notifications = current_user.incoming_notifications
  #   @other_notifications = @notifications.where(project_id: nil)
  #   @project_notifications = @notifications.order(created_at: :desc).select(&:project_id).uniq(&:project_id)
  #   @projects = current_user.projects

  #   @project_messages = @projects.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:project_id).uniq(&:project_id)

  #   @project_correspondence = [ @project_messages, @project_notifications ].flatten.sort_by{ |pc| pc.created_at }.reverse!.select(&:project_id).uniq(&:project_id)

  #   @conversations = current_user.conversations.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:conversation_id).uniq(&:conversation_id)


  #   @inbox = @project_correspondence + @other_notifications + @conversations

  #   @project_notification_types = ["shortlisted", "active", "completed", "invited", "applied"]
  #   @filter_terms = ["All messages", "Project messages", "Other messages"]

  #   if params[:filter_by].present?
  #     @inbox = handle_sorting(@inbox, params[:filter_by]) || [] # or empty array to handle no results
  #     @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
  #   else
  #     @inbox.sort_by!(&:created_at).reverse!
  #     @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
  #   end

  # end

  def index
    @notifications = current_user.incoming_notifications
    #@other_notifications = @notifications.where(project_id: nil)
    #@project_notifications = @notifications.order(created_at: :desc).select(&:project_id).uniq(&:project_id)

    @projects = current_user.projects.select{|p| p if p.messages.present? }

    @project_messages = @projects.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:project_id).uniq(&:business)

    @project_correspondence = [ @project_messages ].flatten.sort_by{ |pc| pc.created_at }.reverse!.select(&:project_id).uniq(&:business)

    @conversations = current_user.conversations.collect(&:messages).flatten.sort_by!(&:created_at).reverse!.select(&:conversation_id).uniq(&:conversation_id)
    
    array = []
    @projects.each do |project|
      project_msgs = @project_messages.select{|a| a if a.project_id == project.id }
      msg_array = [project, project_msgs]
      array << msg_array
    end
    
    @project_message_array = array

    @inbox = @project_correspondence + @conversations #+ @other_notifications 
    
    @active_message = @inbox.first if @inbox.present?
    
    if @inbox.present?
      if @inbox.first.project.present?
        @conversation_messages = @inbox.first.project.messages_with_business(@inbox.first.business).order(created_at: :asc)
        @project = @inbox.first.project
      else
        @conversation = Conversation.find(@inbox.first.conversation_id)
        @conversation_messages = @conversation.messages.order(created_at: :asc)
      end
      @file_messages = @conversation_messages.select{|a| a if a.attachment.present? && a.attachment.attachment_content_type == 'application/pdf' }
      @media_messages = @conversation_messages.select{|a| a if a.attachment.present? && a.attachment.attachment_content_type != 'application/pdf' }
      @link_messages = nil
      @business = @inbox.first.business
      @message = Message.new
      @message.build_attachment
    end

    if params[:filter_by].present?
      #@inbox = handle_sorting(@inbox, params[:filter_by]) || [] # or empty array to handle no results
      @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
    else
      #@inbox.sort_by!(&:created_at).reverse!
      @inbox = Kaminari.paginate_array(@inbox).page(params[:page]).per(6)
    end
  end

  def show
    @inbox = Message.find_by_id(params[:id])
    if @inbox.project.present?
      @conversation_messages = @inbox.project.messages_with_business(@inbox.business).order(created_at: :asc)
    else
      @conversation = Conversation.find(@inbox.conversation_id)
      @conversation_messages = @conversation.messages.order(created_at: :asc)
    end
    @file_messages = @conversation_messages.select{|a| a if a.attachment.present? && a.attachment.attachment_content_type == 'application/pdf' }
    @media_messages = @conversation_messages.select{|a| a if a.attachment.present? && a.attachment.attachment_content_type != 'application/pdf' }
    @link_messages = nil
    @project = @inbox.project
    @business = @inbox.business
    @message = Message.new
    @message.build_attachment
  end
end

