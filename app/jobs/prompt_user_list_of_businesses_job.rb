class PromptUserListOfBusinessesJob < ApplicationJob
  queue_as :default

  def perform
    @target_projects = Project.prompt_list_of_businesses_email_candidates

    @target_projects.each do |project|
      project.send_business_received_project_email
    end

    @target_projects.count
  end

end

