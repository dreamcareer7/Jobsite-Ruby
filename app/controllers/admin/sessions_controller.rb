class Admin::SessionsController < Devise::SessionsController
  layout "no_layout_layout"

  before_action :check_disabled

  private

  def check_disabled
    if current_admin && current_admin.disabled
      sign_out current_admin
      redirect_to root_path
      flash[:error] = "Account disabled."
    end
  end

end
