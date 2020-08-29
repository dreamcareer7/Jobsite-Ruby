class SelfAddedProjectsController < ApplicationController

  impressionist actions: [:index]

  def index
    @business = Business.find(params[:business_id])
    @self_added_projects = @business.self_added_projects
    impressionist(@business, "project_views")
  end

end

