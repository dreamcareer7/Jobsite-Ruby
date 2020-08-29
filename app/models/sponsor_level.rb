class SponsorLevel < ApplicationRecord
  validates :level_name, :listing_targets_count, :location_targets_count, presence: true
end
