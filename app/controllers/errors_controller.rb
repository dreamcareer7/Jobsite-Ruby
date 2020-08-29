class ErrorsController < ApplicationController
  skip_before_action :current_language
  skip_before_action :current_city
  skip_before_action :current_coordinates
  skip_before_action :current_business
  skip_before_action :limit_business_page_views

  layout 'error'

  def not_found
    render status: 404
  end

  def rejected
    render status: 422
  end

  def internal_server_error
    render status: 500
  end

end
