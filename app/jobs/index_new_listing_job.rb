class IndexNewListingJob < ApplicationJob
  queue_as :default

  def perform
    AutoComplete.index_target_terms
  end
end
