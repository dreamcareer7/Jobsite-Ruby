module SortUserProjects
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "Posted"
      @projects = projects.where.not(project_status: [:in_process, :completed, :cancelled])
    when "Active"
      @projects = projects.where(project_status: [:in_process, :completion_pending])
    when "Completed"
      @projects = projects.where(project_status: :completed)
    when "Cancelled"
      @projects = projects.where(project_status: :cancelled)
    when "Ongoingprojects"
      @projects = projects.where(project_status: :in_process)
    when "Unverified"
      @projects = projects.where(approved: 'false')
    else
      @projects = projects
    end

  end

end
