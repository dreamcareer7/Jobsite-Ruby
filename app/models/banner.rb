class Banner < ApplicationRecord
  include SocialUrlHelper

  has_many :banner_targets
  validates :title, presence: true

  validates :link_en, :link_ar, url: true, allow_blank: true

  validates :image_en, :image_ar, if: "destination_type('result banner')", image_dimensions: { width: 1000, height: 400 }
  validates :image_en, :image_ar, if: "destination_type('side banner')", image_dimensions: { width: 366 }
  validates :image_en, :image_ar, if: "destination_type('dashboard banner')", image_dimensions: { width: 366 }

  has_attached_file :image_en, :styles => { small: "64x64", medium: "200x200", large: "600x600", side: "366x306", results: "800x600"} , default_url: "missing/banner.png"
  has_attached_file :image_ar, :styles => { small: "64x64", medium: "200x200", large: "600x600", side: "366x306", results: "800x600"} , default_url: "missing/banner.png"

  validates_attachment_content_type :image_en, :image_ar, :content_type => [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]

  accepts_nested_attributes_for :banner_targets, reject_if: :all_blank

  scope :by_listing, -> (listing) { joins(:banner_targets).where('banner_targets.target_listing_id' => listing) }
  scope :by_location, -> (country) { joins(:banner_targets).where('banner_targets.target_location_id' => country) }
  scope :enabled, -> { where(enabled: true) }
  scope :valid, -> { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).or(where(end_date: nil)) }
  scope :by_banner_type, -> (banner_type) { where('banner_type': banner_type) }

  attr_accessor :banner_listings, :banner_locations, :category_list

  def link_for_locale
    return full_path(self.link_en) if I18n.locale == :en
    return full_path(self.link_ar) if I18n.locale == :ar
  end

  def image_for_locale
    return self.image_en if I18n.locale == :en
    return self.image_ar if I18n.locale == :ar
  end

  def locations
    Country.where(id: self.banner_targets.pluck(:target_location_id))
  end

  def listings
    SubCategory.where(id: self.banner_targets.pluck(:target_listing_id))
  end

  def destination_type(banner_type)
    self.banner_type == banner_type
  end

  private

  class << self

    def relevant_banner(banner_type, location, listing = "")
      banner = Banner.by_banner_type(banner_type)
        .enabled
        .valid
        .by_location(location)
        .distinct

      unless banner_type == "dashboard banner" || banner.blank?
        banner = banner.by_listing(listing)
      end

      banner.present? ? banner.shuffle.first(2) : []
    end

  end

end
