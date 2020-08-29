class CityBanner < ApplicationRecord
  belongs_to :city
  translates :description
  globalize_accessors

  has_attached_file :image, :styles => { small: "300x600", listing_card: "600x600", large: "1600x1400" } , default_url: "missing/banner.png"

  validates_attachment_content_type :image, :content_type => [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]

end
