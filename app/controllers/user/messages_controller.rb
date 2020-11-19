class User::MessagesController < User::BaseController
  include HandleConversations

  def new
    @message = current_user.outgoing_message.new
    @business = Business.find(params[:business_id]) if params[:business_id].present?
  end

  def create
    if params[:p].present? && params[:b].present?
      #creates threaded message on project show page when multiple businesses may be present
      @project = Project.find(params[:p])
      @business = Business.friendly.find(params[:b])

      @new_message = create_message_for_conversation_with_project(@project, @business, current_user)

    elsif params[:conversation_id].present?
      @conversation = Conversation.find(params[:conversation_id])

      @new_message = create_message_for_conversation_without_project(@conversation, current_user)

    elsif session[:target_business].present?
      @business = Business.friendly.find(session[:target_business])

      @new_message = create_message_from_business_listing_page(@business)

    else
      #when no conditions are met return an error
      redirect_back(fallback_location: user_profile_index_path)
      flash[:error] = "The message could not be sent. Try again later."
      return

    end

    if @new_message.save
      redirect_back(fallback_location: user_profile_index_path)
      flash[:notice] = "Message sent."

    else
      redirect_back(fallback_location: user_profile_index_path)
      flash[:error] = "The message could not be sent. Try again later."

    end

  end

  def show
    @message = Message.find(params[:id])
    @conversation = Conversation.find(@message.conversation_id)
    @conversation_messages = @conversation.messages.order(created_at: :asc)
    @business = @message.business

    return if !@business.present?

    if @business.present? && @business.locations.present?
      @business_location = @business.locations.by_city(@current_city).present? ? 
        @business.locations.by_city(@current_city).city_country :
        @business.locations.first.city_country
    end

    @message.mark_as_read

  end

  private

  def message_params
    params.require(:message).permit(:body, :receiving_user_id, :receiving_user_type, :project_id, :conversation_id, :attachment_attributes => [ :id, :attachment, :_destroy ])
  end

end
