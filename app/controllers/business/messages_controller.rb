class Business::MessagesController < Business::BaseController
  include HandleConversations

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  after_action :verify_policy_scoped, only: [:index?, :show?]

  def create
    authorize Message

    if params[:project].present?
      @project = Project.find(params[:project])
      @user = User.find(@project.user.id)

      @new_message = create_message_for_conversation_with_project(@project, @user, current_business)

    else
      @conversation = Conversation.find(params[:conversation_id])

      @new_message = create_message_for_conversation_without_project(@conversation, current_business)
    end


    if @new_message.save
      redirect_back(fallback_location: business_profile_index_path) 
      flash[:notice] = "Message sent."
    else
      redirect_back(fallback_location: business_profile_index_path) 
      flash[:error] = "The message could not be sent. Try again later."
    end
  end

  def show
    authorize Message

    @message = Message.find(params[:id])
    @conversation = Conversation.find(@message.conversation_id)
    @conversation_messages = @conversation.messages.order(created_at: :asc)

    @message.mark_as_read
  end

  private

  def message_params
    params.require(:message).permit(:body, :receiving_user_id, :receiving_user_type, :project_id, :conversation_id, :attachment_attributes => [ :id, :attachment, :_destroy ])
  end

  def policy(record)
    Business::MessagePolicy.new(current_business, record)
  end

  def user_not_authorised
    redirect_back(fallback_location: business_profile_index_path)
    flash[:error] = "Your business has been disabled"
  end

end

