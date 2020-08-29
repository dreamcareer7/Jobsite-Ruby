class ProjectsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised

  def index
    @projects = Project.all
    authorize @projects
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def pundit_user
    @user = @current_business ? @current_business : @current_user
  end

  def user_not_authorised
    redirect_to(request.referrer || default_path)

    flash[:error] = "Sorry, you must upgrade to a standard or premium account to view the project feed."
  end


end
