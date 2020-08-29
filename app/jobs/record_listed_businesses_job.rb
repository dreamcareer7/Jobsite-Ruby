class RecordListedBusinessesJob < ApplicationJob
  queue_as :default

  def perform(businesses)
    businesses.each{ |business| business.impressions.create({ message: "listing_view" }) }
  end
end
