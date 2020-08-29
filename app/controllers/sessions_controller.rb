class SessionsController < Devise::SessionsController
  before_action :check_disabled
  after_action :update_user_location, :check_disabled

  private

  def check_disabled
    if current_user && current_user.disabled
      sign_out current_user
      redirect_to root_path
      flash[:error] = "Account disabled."
    end
  end

  def update_user_location
    if current_user
      current_user.update_attributes(browse_location: @current_city.id)
    end
  end

end
