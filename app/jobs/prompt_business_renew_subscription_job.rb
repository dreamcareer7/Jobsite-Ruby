class PromptBusinessRenewSubscriptionJob < ApplicationJob
  queue_as :default

  def perform
    @target_businesses = Business.prompt_renew_subscription_candidates

    @target_businesses.each do |business|
      business.send_business_renew_subscription_email
    end

    @target_businesses.count
  end

end

