class RegistrationsController < Devise::RegistrationsController
  layout "no_layout_layout"

  def create
    params[:user][:browse_location] = @current_city.id rescue ''
    super
  end

  def confirmation_sent
    @email = params[:email]

    flash[:notice] = "You will receive an email to confirm your account shortly."
    render template: "devise/registrations/confirmation_sent"
  end

  private

  def after_inactive_sign_up_path_for(resource)
    registered_path(email: resource.email)
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :mobile_number, :browse_location)
  end

end
