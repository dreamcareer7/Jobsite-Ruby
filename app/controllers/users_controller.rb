class UsersController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised

  def edit
    current_user.build_location if current_user.location.blank?

    render layout: "user_profile"
    @user = User.find(params[:id])
    authorize @user
  end


  def update
    @user = current_user
    authorize @user

    params[:user].delete(:password) if params[:user][:password].blank?

    if @user.update_attributes(user_params)
      sign_in(@user, :bypass => true)
      redirect_to user_profile_index_path
    else
      redirect_back(fallback_location: user_profile_index_path) 
      flash[:error] = @user.errors.full_messages
    end
  end

  def change_default_profile
    user = User.find(params[:user_id])
    user.update_columns(default_profile: params[:business])
  end

  private

  def user_not_authorised
    redirect_back(fallback_location: user_profile_index_path) 
  end

  def user_params
    params.require(:user).permit(
      :name,
      :password,
      :gender,
      :age,
      :birthday,
      :nationality,
      :industry,
      :city,
      :country,
      :mobile_number,
      :profile_image,
      :location_attributes =>  [ :city_id,
                                  :id,
                                  :_destroy ],
    )

  end

end
