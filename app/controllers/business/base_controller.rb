class Business::BaseController < ApplicationController  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  before_action :authenticate_admin_or_user!, :check_disabled
  layout "business_profile"
  respond_to :html, :json

  private

  def user_not_authorised
    redirect_back(fallback_location: business_profile_index_path) 
  end

  private

  def check_disabled
    if current_user && current_user.disabled
      sign_out current_user
      redirect_to root_path
      flash[:error] = "Account disabled."
    end
  end

end
