class TeamMember < ApplicationRecord
  validates :name, :role, presence: true

  belongs_to :business

  has_attached_file :profile_image, :styles => { small: "200x200", large: "400x400" } , default_url: "missing/contact.png"  

  validates_attachment_content_type :profile_image, :content_type => [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]

  translates :name, :role, fallbacks_for_empty_translations: true
  globalize_accessors

end
