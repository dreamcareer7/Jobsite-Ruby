class CityBanner < ApplicationRecord
  belongs_to :city
  translates :description
  globalize_accessors

  has_attached_file :image, :styles => { small: "300x600", listing_card: "600x600", large: "1600x1400" }, default_url: "missing/banner.png"

  validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/jpg", "image/png", "image/gif"]
  after_commit :clear_cache

  private

  def clear_cache
    I18n.available_locales.each do |locale|
      Rails.cache.fetch("#{Rails.env}_cachedAllCityBanners_#{city_id}_#{locale}")
    end
  end
end
