class Admin::InvitationsController < Devise::InvitationsController
  before_filter :configure_permitted_parameters
  before_filter :verify_superadmin!, except: [:edit, :update]

  layout :resolve_layout

  protected

  def verify_superadmin!
    raise Pundit::NotAuthorizedError, 'must be superadmin to manage admins' if !current_admin.superadmin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite).concat [:role, country_ids: [], city_ids: []]
  end

  def resolve_layout
  case action_name
  when 'new'
    'admin'
  else
    'no_layout_layout'
  end
  end
end
