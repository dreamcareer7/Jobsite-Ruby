class PromptUserRenewSubscriptionJob < ApplicationJob
  queue_as :default

  def perform
    @target_users = User.prompt_renew_subscription_candidates

    @target_users.each do |user|
      user.send_user_renew_subscription_email
    end

    @target_users.count
  end

end
