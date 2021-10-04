module SortBusinessProjects
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "applied"
      @projects = Project.where(id: current_business.applied_to_projects.pluck(:project_id)).where.not(id: current_business.shortlists.pluck(:project_id)).where(business_id: nil).order(updated_at: :desc)
    when "shortlisted"
      @projects = Project.where(id: current_business.shortlists.pluck(:project_id)).order(updated_at: :desc)
    when "posted"
      @projects = projects.where(project_status: :new_project)
    when "active"
      @projects = projects.where(project_status: :in_process)
    when "completed"
      @projects = projects.where(project_status: :completed)
    when "cancelled"
      @projects = projects.where(project_status: :cancelled)
    when "invited"
      @projects = Project.where(id: @current_business.quote_requests.pluck(:project_id))
    else
      @projects
    end

  end

end
