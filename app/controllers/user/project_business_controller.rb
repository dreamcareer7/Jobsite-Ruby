class User::ProjectBusinessController < User::BaseController

  def show
    @project = Project.where(id: params[:project_id]).first

    unless @project.present?
      redirect_back(fallback_location: user_profile_index_path) 
      flash[:error] = "Sorry, that project is no longer available."
      return
    end

    @business = Business.friendly.find(params[:id])
    @active = @business.shortlisted_or_accepted?(@project)
    @quote = @project.quotes.where(business_id: @business.id).first
    @conversation_messages = @project.messages_with_business(@business).order(created_at: :asc)

    mark_as_read

    session[:project] = @project.id
    session[:project_business] = @business.id
  end

  def mark_as_read
    current_user.incoming_notifications
      .where(project_id: @project.id).each{ |notification| notification.mark_as_read }

    @conversation_messages.where(receiving_user_id: current_user.id).each{ |message| message.mark_as_read }

  end

end
