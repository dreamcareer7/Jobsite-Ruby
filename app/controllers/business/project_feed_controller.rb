class Business::ProjectFeedController < Business::BaseController
  include SortProjectFeed

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  after_action :verify_policy_scoped, only: [:index?, :show?]

  def index
    authorize Project

    @services = current_business.services
    @projects = policy_scope(Project).includes(:translations)
      .by_city(@current_business.cities)
      .approved
      .not_completed_or_accepted
      .not_hidden(@current_business.hidden_resources.pluck(:project_id))
      .not_applied(@current_business.applied_to_projects.pluck(:project_id))

    @projects = @projects.by_services(@services)
      .or(@projects.by_sub_categories_no_service(@current_business.sub_categories_where_no_service))

    @filter_terms = ["All projects", "Invited only"]

    if params[:filter_by].present?
      @projects = handle_sorting(@projects, params[:filter_by])

      @project_feed = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)
    else
      @project_feed = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)
    end

  end

  def show

    begin
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: business_profile_index_path)
      flash[:error] = "That project is unavailable."
      return
    end

    authorize @project

    @conversation_messages = @project.messages_with_business(current_business).order(created_at: :asc)
    @active = current_business.shortlisted_or_accepted?(@project)

    mark_as_read
  end

  def mark_as_read
    current_business.incoming_notifications
      .where(project_id: @project.id).each{ |notification| notification.mark_as_read }

    @conversation_messages.where(receiving_user_id: current_business.id).each{ |message| message.mark_as_read }

  end

  private

  def pundit_user
    current_business
  end

  def policy(record)
    Business::ProjectFeedPolicy.new(current_business, record)
  end

  def user_not_authorised
    redirect_back(fallback_location: business_profile_index_path)
    if current_business.disabled?
      flash[:error] = "Your business has been disabled"
    else
      flash[:error] = "Sorry, you must be a standard or premium business to view projects from the project feed."
    end
  end


end
