class CacheBusinessRankingJob < ApplicationJob
  queue_as :default

  def perform(business)
    business.update(cached_ranking: business.ranking)
  end
end
