class SelfAddedProject < ApplicationRecord

  validates :title, :description, presence: true

  belongs_to :business, counter_cache: true

  has_attached_file :image_one, :styles => { small: "200x200", medium: "300x600", large: "1600x400"} , default_url: "default_photos/:style/missing.png"  
  has_attached_file :image_two, :styles => { small: "200x200", medium: "300x600", large: "1600x400"} , default_url: "default_photos/:style/missing.png"  
  has_attached_file :image_three, :styles => { small: "200x200", medium: "300x600", large: "1600x400"} , default_url: "default_photos/:style/missing.png"  

  validates_attachment_content_type :image_one, :image_two, :image_three, :content_type => [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]

  translates :title, :description, fallbacks_for_empty_translations: true
  globalize_accessors

  scope :has_photos, -> { where("image_one_file_name != 'nil' OR image_two_file_name != 'nil' OR image_three_file_name != 'nil'") }
  scope :has_video, -> { where.not(video_link: nil) }
  scope :by_city, -> (city) { joins(:business).merge(Business.by_city(city)) }
  scope :new_projects, -> { has_photos.order(created_at: :desc) }



  def photos
    [ (self.image_one if self.image_one.present?), 
      (self.image_two if self.image_two.present?), 
      (self.image_three if self.image_three.present?) ].compact
  end

end
