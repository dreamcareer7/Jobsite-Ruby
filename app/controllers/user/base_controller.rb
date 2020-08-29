class User::BaseController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised

  before_action :auth_user_or_admin, :check_disabled
  respond_to :html, :json
  layout "user_profile"

  private

  def check_disabled
    if current_user && current_user.disabled
      sign_out current_user
      redirect_to root_path
      flash[:error] = "Account disabled."
    end
  end

  def auth_user_or_admin
    if current_user
      authenticate_user!
    elsif current_admin
      true
    else
      false
    end
  end

end
