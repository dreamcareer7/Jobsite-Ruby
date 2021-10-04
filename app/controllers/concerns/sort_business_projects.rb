module SortBusinessProjects
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "Applied"
      @projects = Project.where(id: current_business.applied_to_projects.pluck(:project_id)).where.not(id: current_business.shortlists.pluck(:project_id)).where(business_id: nil).order(updated_at: :desc)
    when "Shortlisted"
      @projects = Project.where(id: current_business.shortlists.pluck(:project_id)).order(updated_at: :desc)
    when "posted"
      @projects = projects.where(project_status: :new_project)
    when "Active"
      @projects = projects.where(project_status: :in_process)
    when "Completed"
      @projects = projects.where(project_status: :completed)
    when "Cancelled"
      @projects = projects.where(project_status: :cancelled)
    else
      @projects
    end

  end

end
