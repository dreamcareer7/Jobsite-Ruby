class PhotoGallery < ApplicationRecord

  attr_accessor :attachment

  validates :owner, presence: true

  belongs_to :owner, polymorphic: true
  has_many :attachments, as: :owner, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

end
