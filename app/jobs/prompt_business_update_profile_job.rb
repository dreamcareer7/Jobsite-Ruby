class PromptBusinessUpdateProfileJob < ApplicationJob
  queue_as :default

  def perform
    @target_businesses = Business.prompt_update_profile_candidates

    @target_businesses.each do |business|
      business.send_business_update_profile_prompt_email
    end

    @target_businesses.count
  end

end

