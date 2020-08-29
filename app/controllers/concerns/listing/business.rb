module Listing::Business
  extend ActiveSupport::Concern

  FEATURED_BUSINESS_COUNT = 3

  def get_featured_businesses(businesses)
    businesses.order(cached_ranking: :desc).limit(FEATURED_BUSINESS_COUNT)
  end
end

