class Business::ProjectsController < Business::BaseController
  include SortBusinessProjects
  include HandleProjectActions
  before_action :set_project
  skip_before_action :set_project, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  after_action :verify_policy_scoped, only: [:index?, :show?]

  def index
    authorize Project

    @projects = Project.where(id: @current_business.applied_to_projects.pluck(:project_id))
      .or(Project.where(id: @current_business.shortlists.pluck(:project_id)))
      .or(Project.where(business_id: @current_business.id))

    @filter_terms = ["All projects", "Applied", "Shortlisted", "Active", "Completed", "Cancelled"]

    if params[:filter_by].present?
      @projects = handle_sorting(@projects, params[:filter_by]) || [] # or empty array to handle no results
      @projects = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)
    else
      @projects = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)
    end
  end

  def show
    authorize @project
  end

  private

  def set_project
    @project = Project.find(params[:project_id].present? ? params[:project_id] : params[:id])
  end

  def pundit_user
    current_business
  end

  def policy(record)
    Business::ProjectPolicy.new(current_business, record)
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
