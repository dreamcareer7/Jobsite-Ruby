class CategoryMetadata < ApplicationRecord

  belongs_to :owner, polymorphic: true

  has_attached_file :banner, styles: { small: "300x600", square: "600x600", large: "1600x400" }, default_url: "missing/banner.png"
  validates_attachment_content_type :banner, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  translates :subheadline, fallbacks_for_empty_translations: true
  translates :subheadline
  globalize_accessors

end
