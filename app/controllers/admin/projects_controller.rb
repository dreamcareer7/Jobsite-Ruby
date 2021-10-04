class Admin::ProjectsController < Admin::BaseController
  include EmailHelper

  before_action :set_project, only: [:edit, :update, :destroy, :show, :add_matching_business]
  #after_action :verify_authorized

  def index
    #authorize Project

    respond_to do |format|
      format.html
      format.json { render json: ProjectDatatable.new(view_context) }
    end
  end

  def edit
    @cities = City.all.enabled
    @countries = Country.all.enabled
    @category = @project.category
    @category_name = I18n.with_locale(:en) { @category.name }
    @project_types = ProjectType.appropriate_project_types(@category)
    @project_types = ProjectType.where(id: @project_types.collect(&:id).uniq)
    @services = @project.sub_categories.present? ? @project.sub_categories.first.services : @category.services
    @edit_path = admin_project_path(@project)
    @interactions = @project.shortlists + @project.applied_to_projects
    @interactions << @project.business if @project.business.present?
    @target_businesses = @project.matching_businesses.includes(:cities, :services)
    @project_matching_business = ProjectsMatchingBusiness.new
  end

  def show
    #authorize @project
    resolve_notification
  end

  def update
    @category = @project.category
    @services = @category.services
    @edit_path = admin_project_path(@project)

    if @project.update_attributes(project_params)
      redirect_to admin_projects_path
      flash[:notice] = "Project was updated."
    else
      redirect_back(fallback_location: admin_projects_path)
      flash[:notice] = "There was an error updating the project."
    end
  end

  def destroy
    #authorize @project

    if @project.destroy
      redirect_to admin_projects_path
      flash[:notice] = "Project was deleted."
      send_project_deleted_email(@project)
    else
      redirect_to admin_projects_path
      flash[:notice] = "There was an error deleting the project."
    end
  end

  def resolve_notification
    unresolved_notification = AdminNotification.where(project: @project, resolved: false).first

    unresolved_notification.update(resolved: true) if unresolved_notification.present?
  end

  def add_matching_business
    ProjectsMatchingBusiness.create(project_matching_business_params)
    redirect_to edit_admin_project_path(@project, anchor: 'tabs_matching_businesses')
  end

  def delete_matching_business
    ProjectsMatchingBusiness.where(project_id: params[:id], business_id: params[:business_id]).delete_all
    redirect_to edit_admin_project_path(params[:id], anchor: 'tabs_matching_businesses')
  end

  protected

  def set_project
    @project = Project.find(params[:id])
  end

  def project_matching_business_params
    params[:projects_matching_business][:project_id] = @project.id
    params[:projects_matching_business][:order] = @project.matching_businesses.size + 1
    params[:projects_matching_business][:automatic_match] = false
    params.require(:projects_matching_business).permit(:project_id, :order, :automatic_match, :business_id)
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
      :project_types,
      :user_id,
      :project_stage,
      :category_id,
      :project_owner_type,
      :contact_name,
      :contact_email,
      :contact_number,
      :contact_role,
      :approved,
      :project_type_ids => [],
      :location_attributes => [:city_id, :street_address, :latitude, :longitude],
      :project_services_attributes => [:id, :service_id, :quantity, :details, :option, :_destroy, :service_id => []],
      :service_ids => [],
      :attachments_attributes => [:id, :attachment, :_destroy],
    )
  end
end
