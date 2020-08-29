class PromptBusinessUpgradeJob < ApplicationJob
  queue_as :default

  def perform
    @target_businesses = Business.prompt_upgrade_candidates

    @target_businesses.each do |business|
      business.send_business_upgrade_prompt_email
    end

    @target_businesses.count
  end

end
