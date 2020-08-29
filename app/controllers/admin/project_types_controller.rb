class Admin::ProjectTypesController < Admin::BaseController
  before_action :set_project_type, only: [:edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ProjectTypeDatatable.new(view_context) }
    end
  end

  def new
    @project_type = ProjectType.new
  end

  def create
    @project_type = ProjectType.create(project_types_params)
    redirect_to admin_project_types_path
  end

  def edit
  end

  def update
    if @project_type.update_attributes(project_types_params)
      redirect_to admin_project_types_path
    else
      render 'edit'
    end
  end

  def destroy
    @project_type.destroy
    redirect_back(fallback_location: admin_project_types_path)
  end

  protected

  def set_project_type
    @project_type = ProjectType.find(params[:id])
  end

  def project_types_params
    params.require(:project_type).permit(
      :name_en,
      :name_ar,
      :category_type
    )
  end

end

