class User::ProjectStepsController < User::BaseController
  include Wicked::Wizard
  include FilterServices
  include RestoreProjectOnError
  include EmailHelper

  steps :project_details

  def show
    handle_prefilled_project_type
    project_type_header
    @countries = Country.enabled.includes(:translations)
    @cities = City.enabled

    @edit_path = wizard_path
    @project = Project.find(params[:project_id])
    #@project.update_attributes(category_id: @project_type.id)

    if ["supplier", "suppliers"].include? params[:project_type]
      @project_category = Category.find { |c| c.name_en == "Suppliers" }
      #@project_category = Category.find_by(name: "Suppliers")
    elsif params[:project_type] == "machinery"
      @project_category = Category.find { |c| c.name_en == "Machinery" } #Category.find_by(name: "Machinery")
    else
      @project_category = Category.find { |c| c.name_en == "Consultants" }
      #@project_category = Category.find_by(name: "Consultants")
    end

    if @project.category_id.nil?
      @project.update_attributes(category_id: @project_category.id)
    end
    @category = Category.find(@project.category_id)
    @category_name = I18n.with_locale(:en) { @category.name }
    @project_types = CachedItems.category_types(@category) #  ProjectType.appropriate_project_types(@category)
    @services = @category ? @category.services : Service.all
    restore_on_validation_error

    @project.attachments.build if step == :project_details
    @project.build_location if step == :project_details && @project.location.blank?
    @project.project_services.build #if step == :additional_information

    if params[:sort_by].present?
      @services = SubCategory.find(params[:sort_by]).services.visible
    end

    render_wizard
  end

  def update
    @edit_path = wizard_path
    @project = Project.find(params[:project_id])
    @finished = false
    params[:project][:user_id] = current_user.id

    required_category = params[:project][:required_category]

    if required_category.nil? && step == :project_details
      #store in session for restore
      session[:restore_project] = params

      redirect_back(fallback_location: user_profile_index_path)
      flash[:error] = "Please specify a main category for your project."
      return
    end

    ##check subcategory

    if @project.update_attributes(project_params)
      params[:project][:creation_status] = step.to_s

      if required_category.present?
        @project.update_attributes(category_id: required_category, project_status: :new_project)
      end

      final_step(params[:project], "active") if step == steps.last

      return if @finished

      render_wizard @project
    else
      session[:restore_project] = params
      redirect_back(fallback_location: user_profile_index_path)
      flash[:error] = @project.errors.full_messages.first
    end
  end

  def check_next_step
    #used to decide which form to push to after basic details are inputted and submitted
    return unless step == :additional_information

    project = Project.find(params[:project_id])

    Category.find(project.category_id)
  end

  def final_step(params, creation_status)
    @project.update_columns(creation_status: creation_status)

    @finished = true

    if @project.creation_status == "skip"
      @project.destroy
      redirect_to user_profile_index_path
      flash[:error] = "No projects were created"
      return
    elsif @project.creation_status == "active"
      redirect_to user_project_path(@project)
      flash[:notice] = "Project created"

      send_project_posted_email(@project)
      send_notify_admin_project_new_project(@project)
      AdminNotification.new_project_notification(@project)

      return
    end
  end

  def skip
    @project = Project.find(params[:project_id])

    final_step(params[:project], "skip")

    return if @finished

    render_wizard @project
  end

  def handle_prefilled_project_type
    return unless params[:project_type].present?

    if ["supplier", "suppliers"].include? params[:project_type]
      @project_type = [Category.find { |c| c.name_en == "Suppliers" }]
    elsif params[:project_type] == "machinery"
      @project_type = [Category.find { |c| c.name_en == "Machinery" }]
    else
      @project_type = Category.where.not(name: ["Suppliers", "Machinery"])
    end
  end

  def project_type_header
    #@project_type_header = I18n.t("main_nav.hire_professional") unless params[:project_type].present?

    if ["supplier", "suppliers"].include? params[:project_type]
      @project_type_header = I18n.t("main_nav.get_supplies")
    elsif params[:project_type] == "machinery"
      @project_type_header = I18n.t("main_nav.buy_rent")
    else
      @project_type_header = I18n.t("main_nav.hire_professional")
    end

    @project_type_header
  end

  private

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
      :currency_type,
      :project_status,
      :creation_status,
      :project_budget,
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
      :location_attributes => [:city_id, :street_address, :latitude, :longitude],
      :project_services_attributes => [:id, :service_id, :quantity, :details, :option, :_destroy, :service_id => []],
      :service_ids => [],
      :attachments_attributes => [:id, :attachment, :_destroy],
    )
  end
end
