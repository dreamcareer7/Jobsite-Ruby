
class User::ProjectsController < User::BaseController
  #include Wicked::Wizard
  include SortAppliedAndShortlisted
  include SortUserProjects
  include FilterServices
  include RestoreProjectOnError
  include HandleProjectActions

  before_action :set_project
  before_action :suggest_businesses, only: :show

  skip_before_action :set_project, only: [:index, :new, :create]
  

  def category_details
    #sleep 200
    @category = Category.find(params[:category_id])
    @project_types = ProjectType.cached_appropriate_project_types(@category.id) #CachedItems.category_types(@category) #ProjectType.appropriate_project_types(@category)
    render :layout => false
  end

  def index
    @projects = current_user.projects.includes(country: :translations, city: :translations, shortlists: :business)
    @filter_terms = ["All projects", "Unverified", "Active", "Ongoing projects", "Completed", "Cancelled"]

    if params[:filter_by].present?
      @projects = handle_sorting(@projects, params[:filter_by]) || [] # or empty array to handle no results
      @projects = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)
    else
      @projects = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)
    end
  end

  def new
    authorize Project.new
    @project = Project.create
    @project_type = params[:project_type]

    if Rails.env.production? and ENV["ON_TESTING_PROD"].nil?
      redirect_to user_project_project_step_url(id: 'project_details', project_id: @project.id, project_type: @project_type, protocol: :https)
    else
      redirect_to user_project_project_step_path(id: 'project_details', project_id: @project.id, project_type: @project_type)
    end
  end

  def create
    @project = current_user.projects.create(project_params)

    if @project.save
      redirect_to user_project_path(@project)
    else
      render :new
    end
  end

  def show
    authorize @project
    @project_types = ProjectType.appropriate_project_types(@project.category)
    @filter_terms = ["Shortlisted (#{ @project.number_shortlisted })", "Interested (#{ @project.number_applied })"]
    @businesses = Business.where(id: @project.shortlists.pluck(:business_id))

    if params[:filter_by].present?
      @businesses = sort_businesses(@businesses, params[:filter_by]) || [] # or empty array to handle no results
      @businesses = Kaminari.paginate_array(@businesses.order(updated_at: :desc)).page(params[:page]).per(6)
    else
      @businesses = Kaminari.paginate_array(@businesses.order(updated_at: :desc)).page(params[:page]).per(6)
    end
  end

  def edit
    @cities = City.all.enabled
    @countries = Country.all.enabled
    @category = @project.category
    @project_types = ProjectType.appropriate_project_types(@category)
    @services = @project.sub_categories.present? ? @project.sub_categories.first.services : @category.services
    project_type_header
    @edit_path = user_project_path(@project)
    authorize @project
  end

  def update
    @category = @project.category
    @services = @category.services
    @edit_path = user_project_path(@project)

    if @project.update_attributes(project_params)
      redirect_to user_project_path(@project)
      flash[:notice] = "Your project updates have been successful"
    else
      @project_types = ProjectType.appropriate_project_types(@category)
      render :edit
    end
  end

  def destroy
    authorize @project
    @project.destroy
      respond_to do |format|
      format.html { redirect_to user_projects_path }
      format.js { render layout: false }
    end
  end

  def project_type_header
    # @project_type_header = I18n.t("main_nav.hire_professional") unless params[:project_type].present?

    
    if @category.slug == "suppliers"
      @project_type_header = I18n.t("main_nav.get_supplies")
    elsif @category.slug == "machinery"
      @project_type_header = I18n.t("main_nav.buy_rent")
    else
      @project_type_header = I18n.t("main_nav.hire_professional")
    end

    @project_type_header
  end

  def project_details
    #authorize @project
  end

  private

  def user_not_authorised
    redirect_back(fallback_location: user_profile_index_path) 
    flash[:error] = "Sorry, you must be a pro user to post more than 3 projects a month."
  end

  def project_params
    # First element in collection select is blank
    params[:project][:service_ids].reject!(&:blank?) if params[:project][:service_ids].present?
    params[:project][:project_type_ids].reject!(&:blank?) if params[:project][:project_type_ids].present?

    params.require(:project).permit(
      :title, 
      :description, 
      :start_date, 
      :end_date, 
      :budget,
      :timeline_type,
      :status, 
      :creation_status, 
      :project_budget, 
      :currency_type,
      :historical_structure, 
      :location_type, 
      :user_id, 
      :category_id, 
      :project_owner_type,
      :contact_name,
      :contact_email,
      :contact_number,
      :contact_role,
      :project_type_ids => [],
      :project_services_attributes => [ :id, :service_id, :quantity, :details, :option, :_destroy, :service_id => [] ], 
      :service_ids => [],
      :location_attributes => [ :city_id, :street_address, :latitude, :longitude ],
      :attachments_attributes => [ :id, :attachment, :_destroy ])
  end

  def set_project
    @project = Project.where(id: params[:project_id].present? ? params[:project_id] : params[:id]).first

    unless @project.present?
      redirect_back(fallback_location: user_profile_index_path) 
      flash[:error] = "Sorry, that project is no longer available."
    end
  end

end
