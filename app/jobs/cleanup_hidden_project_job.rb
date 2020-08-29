class CleanupHiddenProjectJob < ApplicationJob
  queue_as :default

  def perform(business, project)
    @applied = AppliedToProject.where(business_id: business.id, project_id: project.id)
    @applied.destroy_all

    @invited = QuoteRequest.where(business_id: business.id, project_id: project.id)
    @invited.destroy_all

    @quotes = Quote.where(business_id: business.id, project_id: project.id)
    @quotes.destroy_all

    @shortlists = Shortlist.where(business_id: business.id, project_id: project.id)
    @shortlists.destroy_all
  end
end
