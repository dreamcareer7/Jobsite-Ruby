class Sponsor < ApplicationRecord
  belongs_to :listing_owner, polymorphic: true
  belongs_to :location_owner, polymorphic: true

  validates :listing_owner, :location_owner, presence: true
end
