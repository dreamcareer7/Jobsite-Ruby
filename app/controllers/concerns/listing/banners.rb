module Listing::Banners
  extend ActiveSupport::Concern

  def banners(listing_target)

    @listing_banner = listing_target.metadata_banner

    @result_banners = Banner.relevant_banner(
      "result banner",
      @current_city.country,
      listing_target
    )

    @side_banners = Banner.relevant_banner(
      "side banner",
      @current_city.country,
      listing_target
    )

  end
end
