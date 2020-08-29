class Admin::BaseController < ApplicationController
  skip_before_action :current_business
  skip_before_action :limit_business_page_views

  before_action :authenticate_admin!, :check_disabled, :get_notifications
  layout "admin"
  respond_to :html, :json

  # This route will redirect an incoming user to the appropriate admin panel homepage depending on their permission level

  def select_country
    if params['admin_country']['country_id'].blank?
      session.delete(:admin_country_id)
    else
      session[:admin_country_id] = params['admin_country']['country_id']
    end

    redirect_back(fallback_location: admin_businesses_path)
  end

  def pundit_user
    current_admin
  end

  private

  def check_disabled
    if current_admin && current_admin.disabled
      sign_out current_admin
      redirect_to root_path
      flash[:error] = "Account disabled."
    end
  end

  def get_notifications
    @notifications = AdminNotification.all
  end

end
