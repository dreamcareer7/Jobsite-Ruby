class PromptBusinessOutstandingQuoteRequestsJob < ApplicationJob
  queue_as :default

  def perform
    @target_businesses = Business.prompt_outstanding_quote_requests_candidates

    @target_businesses.each do |business|
      business.send_outstanding_quote_requests_email
    end

    @target_businesses.count
  end

end

