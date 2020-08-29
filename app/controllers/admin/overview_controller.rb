class Admin::OverviewController < Admin::BaseController

  def index
    @total_businesses = Business.includes(:translations)
    @total_new_businesses = @total_businesses.new_since(30)
    @total_unapproved_businesses = @total_businesses.pending

    @total_projects = Project.includes(:translations)
    @total_new_projects = @total_businesses.new_since(30)
    @total_unapproved_projects = @total_projects.pending
  end

end
