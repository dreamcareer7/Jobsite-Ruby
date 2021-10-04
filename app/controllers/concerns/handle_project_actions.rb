module HandleProjectActions
  extend ActiveSupport::Concern
  include EmailHelper
  include HandleConversations

  def apply_to_project
    #business applies to project
    if @current_business.user_id != @project.user_id
      AppliedToProject.create(
        business_id: @current_business.id,
        project_id: @project.id)

      #send notification to user
      Notification.send_applied_to_project(@project, @current_business)

      send_new_project_applicant_email(@project, @current_business)

      redirect_to business_project_feed_index_path
      flash[:notice] = "Applied to project."
    else
      flash[:error] = "You cannot apply to a project you posted."
    end
  end

  def shortlist_business
    #user shortlists business
    @business = Business.find(params[:business_id])

    @project.shortlist_business(@business)

    if @project.save
      #send notification to business
      params[:message] = {}
      params[:message][:project_id] = @project.id
      params[:message][:body] = @project.description

      @new_message = create_message_from_business_listing_page(@business)
      @new_message.save

      Notification.send_shortlisted(@project, @business)
      # Notification.send_quote_request(QuoteRequest.create(project: @project, user: current_user, business: @business))
      send_shortlisted_email(@project, @business)
      send_notify_admin_business_shortlisted_email(@project, @business)

      redirect_to user_inbox_index_path
      flash[:notice] = "Business shortlisted."
    else
      redirect_back(fallback_location: user_projects_path)
      flash[:error] = "Business could not be shortlisted. Please try again later."
    end

  end

  def unshortlist_business
    #user shortlists business
    @business = Business.find(params[:business_id])

    @project.unshortlist_business(@business)

    if @project.save
      #send notification to business

      Notification.send_rejected(@project, @business)
      # Notification.send_quote_request(QuoteRequest.create(project: @project, user: current_user, business: @business))
      send_project_cancelled_by_user_email(@project, @business)
      send_notify_admin_project_cancelled_email(@project)

      redirect_to user_inbox_index_path
      flash[:notice] = "Business rejected."
    else
      redirect_back(fallback_location: user_projects_path)
      flash[:error] = "Business could not be rejected. Please try again later."
    end
  end

  def accept_quote
    #user accepts quote from business
    @quote = Quote.find(params[:quote_id])
    @business = @quote.business

    @project.update_attributes(business_id: @business.id, project_status: :in_process)

    if @project.save
      #send notification to business
      Notification.send_accepted(@project, @business)
      send_hired_for_project_email(@project, @business)
      send_notify_admin_business_hired_email(@project, @business)

      params[:message] = {}
      params[:message][:project_id] = @project.id
      params[:message][:receiving_user_id] = @business.id
      params[:message][:receiving_user_type] = "Business"
      params[:message][:body] = "Congrats you got hired" 
      new_message = @current_user.outgoing_messages.create(message_params)

      #remove other shortlisted and applied businesses
      cleanup_shortlists_and_applied(@project, @business)

      redirect_back(fallback_location: user_projects_path)
      flash[:notice] = "Business has been hired."
    else
      redirect_back(fallback_location: user_projects_path)
      flash[:error] = "There was a problem hiring this business."
    end

  end

  def cleanup_shortlists_and_applied(project, chosen_business)
    @businesses = Business.where(id: project.shortlists.pluck(:business_id))

    @businesses.each do |business|
      next if business == chosen_business
      Notification.send_not_chosen(@project, business)
    end

    CleanupShortlistAppliedJob.perform_later(@project)
  end

  def confirm_completion
    #user confirms a project is complete
    @project.update_status(:completed)

    Notification.send_confirm_completion(@project, @project.business)
    send_project_confirmed_complete_email(@project, @project.business)
    send_notify_admin_project_complete_email(@project)
    send_project_follow_up_email(@project)
    #user reviews business
    redirect_to new_user_review_path(project_id: @project)
    flash[:notice] = "Project marked as complete."
  end

  def mark_as_complete
    #business marks a project as complete
    @project.update_status(:completion_pending)

    #send notification to user
    Notification.send_pending_completion(@project, @current_business)
    send_project_marked_complete_email(@project)

    redirect_back(fallback_location: business_profile_index_path) 
    flash[:notice] = "Project marked as complete."
  end

  def deny_completion
    #user denies project completion & switches project status back to active
    @project.update_status(:in_process)
    @business = @project.business

    #send notification business
    Notification.send_deny_pending_completion(@project, @business)

    redirect_back(fallback_location: user_projects_path)
    flash[:notice] = "Project as incomplete."
  end

  def cancel_project_by_user
    #user cancels project
    @project.update_status(:cancelled)
    #all businesses that have been shortlisted or have applied are notified
    business_ids = @project.shortlists.pluck(:business_id) + @project.applied_to_projects.pluck(:business_id)
    businesses = Business.where(id: business_ids)
    send_notify_admin_project_cancelled_email(@project)

    businesses.each do |business|
      Notification.send_project_cancelled_by_user(@project, business)
      send_project_cancelled_email(@project, business)
    end

    CleanupShortlistAppliedJob.perform_later(@project)

    redirect_back(fallback_location: user_projects_path)
    flash[:notice] = "Project cancelled."
  end

  def cancel_project_by_business
    #business cancels project
    @project.update_status(:cancelled)
    #user is notified
    Notification.send_project_cancelled_by_business(@project, @current_business)
    send_project_cancelled_by_business_email(@project)
    send_notify_admin_project_cancelled_email(@project)

    redirect_back(fallback_location: business_profile_index_path) 
    flash[:notice] = "Project cancelled."
  end

  def suggest_businesses 
    #if the project has not created any quote requests then pop a modal suggesting businesses
    #view has content_for :page_scripts that checks if this value is true and pops modal accordingly

    if @project.present? && 
        @project.shortlists.blank? && 
        @project.applied_to_projects.blank? && 
        @project.quote_requests.blank? &&
        @project.created_at > 10.minutes.ago

      @suggested_businesses = @project.suggested_businesses

      @suggest_businesses = true
    end

  end

  def hide_business
    #user hides business from applied or shortlisted
    @business = Business.where(id: params[:business_id]).first

    if @business.present?

      HiddenResource.create(
        business_id: @business, 
        project_id: @project.id)

      if @project.shortlists.pluck(:business_id).include?(@business.id)
        Notification.send_business_hidden_by_user(@project, @business)
      end

      CleanupHiddenProjectJob.perform_later(@business, @project)

      redirect_to user_project_path(@project)
      flash[:notice] = "Business hidden."
    else

      redirect_to user_project_path(@project)
      flash[:error] = "There was a problem hiding this business."
    end
  end

  def hide_project
    #business hides project from project view and from shortlists/applied
    HiddenResource.create(
      business_id: @current_business.id, 
      project_id: @project.id)

    #if the business was shortlisted, notify user
    if @project.shortlists.pluck(:business_id).include?(@current_business.id)
      Notification.send_project_hidden_by_business(@project, @current_business)
    end

    CleanupHiddenProjectJob.perform_later(@current_business, @project)

    redirect_to business_project_feed_index_path
    flash[:notice] = "Project hidden."

  end

  def message_params
    params.require(:message).permit(:body, :receiving_user_id, :receiving_user_type, :project_id, :conversation_id, :attachment_attributes => [ :id, :attachment, :_destroy ])
  end
end
