class PromptUserUpdateProfileJob < ApplicationJob
  queue_as :default

  def perform
    @target_users = User.prompt_update_profile_candidates

    @target_users.each do |user|
      user.send_user_update_profile_prompt_email
    end

    @target_users.count
  end

end
