class PromptUserCheckQuotesJob < ApplicationJob
  queue_as :default

  def perform
    @target_projects = Project.prompt_check_quotes_candidates

    @target_projects.each do |project|
      project.send_check_quotes_email
    end

    @target_projects.count
  end

end
