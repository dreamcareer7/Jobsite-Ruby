class PromptBusinessInactiveJob < ApplicationJob
  queue_as :default

  def perform
    @target_businesses = Business.prompt_inactive_candidates

    @target_businesses.each do |business|
      business.send_inactive_business_email
    end

    @target_businesses.count
  end

end

