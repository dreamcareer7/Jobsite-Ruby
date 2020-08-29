class Admin::VendorsController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy, :enable, :disable]
  after_action :verify_authorized

  def index
    authorize User

    respond_to do |format|
      format.html
      format.json { render json: VendorDatatable.new( view_context ) }
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if params[:user][:password].length == 0
      params[:user][:password].delete
    end

    @user.update_attributes( user_params )
  end

  protected

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :gender,
      :age,
      :birthday,
      :nationality,
      :industry,
      :mobile_number,
      :profile_image
    )
  end

  def policy(record)
    Admin::VendorPolicy.new(current_admin, record)
  end

end
