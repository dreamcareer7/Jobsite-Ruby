class ConfirmationsController < Devise::ConfirmationsController

  protected

  def after_confirmation_path_for(resource_name, resource)
    if resource_name == :user
      sign_in(resource, :bypass => true)
      user_profile_index_path
      #new_user_session_path(email: resource.email)
    else
      super(resource_name, resource)
    end
  end

end
