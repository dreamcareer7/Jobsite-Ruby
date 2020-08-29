class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:update, :destroy, :enable, :disable]

  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def show
    render 'edit'
  end

  def new
    @user = User.new
    @user.build_location if @user.location.blank?
  end

  def create
    @user = User.create(user_params)
  end

  def edit
    @user = User.includes(:projects, :subscriptions).references(:project, :subscripton).find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      redirect_back(fallback_location: edit)
      flash[:notice] = "User updated."
    else
      flash[:error] = @user.errors.full_messages
      redirect_back(fallback_location: edit)
    end
  end

  def destroy
    @user.destroy
    redirect_back(fallback_location: index)
  end

  def enable
    @user.update(disabled: false)
    redirect_back(fallback_location: index)
  end

  def disable
    @user.update(disabled: true)
    redirect_back(fallback_location: index)
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

end
