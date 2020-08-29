class Business::SwitchBusinessController < Business::BaseController

  def switch_business
    session[:business_id] = params[:business]
    redirect_to business_profile_index_path
  end

end
