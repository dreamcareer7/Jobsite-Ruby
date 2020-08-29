class Admin::AdminsController < Admin::BaseController
  before_action :set_admin, only: [:edit, :update, :destroy, :enable, :disable]
  after_action :verify_authorized

  def index
    authorize Admin

    respond_to do |format|
      format.html
      format.json { render json: AdminDatatable.new(view_context) }
    end
  end

  def edit
    authorize @admin
  end

  def update
    authorize @admin

    if @admin.update_attributes(admin_params)
      redirect_to admin_admins_path
    else
      render :edit
    end
  end

  def destroy
    authorize @admin

    @admin.destroy
    redirect_back(fallback_location: admin_admins_path)
  end

  def enable
    authorize @admin

    @admin.update(disabled: false)
    redirect_back(fallback_location: admin_admins_path)
  end

  def disable
    authorize @admin

    @admin.update(disabled: true)
    redirect_back(fallback_location: admin_admins_path)
  end

  protected

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:user).permit(:name, :email, :role, country_ids: [], city_ids: [])
  end

  def policy(record)
    Admin::AdminPolicy.new(current_admin, record)
  end

end
