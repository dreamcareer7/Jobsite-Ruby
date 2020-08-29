class Certification < ApplicationRecord

  belongs_to :country
	has_many :business_certifications

	has_attached_file :logo, styles: { small: "80x80" }, default_url: "certifications/iso.png"
	validates_attachment_content_type :logo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors

end
