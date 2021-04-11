class CategoryMetadata < ApplicationRecord
  belongs_to :owner, polymorphic: true

  has_attached_file :banner, styles: { small: "300x600", square: "600x600", large: "1600x400" }, default_url: "missing/banner.png"
  validates_attachment_content_type :banner, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  translates :subheadline, fallbacks_for_empty_translations: true
  translates :subheadline
  globalize_accessors

  after_commit :clear_cache

  private

  def clear_cache
    I18n.available_locales.each do |locale|
      Rails.cache.delete("#{Rails.env}_cached_trendingn_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_all_site_categories_#{locale}")
    end
  end
end
