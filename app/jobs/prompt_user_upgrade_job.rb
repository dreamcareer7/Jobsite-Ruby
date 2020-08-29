class PromptUserUpgradeJob < ApplicationJob
  queue_as :default

  def perform
    @target_users = User.prompt_upgrade_candidates

    @target_users.each do |user|
      user.send_user_upgrade_prompt_email
    end

    @target_users.count
  end

end
