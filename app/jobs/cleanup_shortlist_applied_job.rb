class CleanupShortlistAppliedJob < ApplicationJob
  queue_as :default

  def perform(project)
    project.shortlists.destroy_all
    project.applied_to_projects.destroy_all
  end
end


