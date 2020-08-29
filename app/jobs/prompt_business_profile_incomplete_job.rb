class PromptBusinessProfileIncompleteJob < ApplicationJob
  queue_as :default

  def perform
    @target_businesses = Business.prompt_update_incomplete_profile_candidates

    @target_businesses.each do |business|
      business.send_business_profile_incomplete_email
    end

    @target_businesses.count
  end

end
