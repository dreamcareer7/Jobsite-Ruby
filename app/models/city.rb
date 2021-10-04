class City < ApplicationRecord
  include Localise::UserDistance

  validates :name, :country, presence: true

  belongs_to :country
  has_many :locations
  has_many :city_banners
  has_many :businesses, through: :locations, source: :owner, source_type: 'Business'
  has_many :users, through: :locations, source: :owner, source_type: 'User'

  has_attached_file :banner, :styles => { small: "300x600", large: "1600x1000" } , default_url: "missing/defaultcity.jpg"
  validates_attachment_content_type :banner, :content_type => [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]

  geocoded_by :city_country

  after_validation :geocode, if: ->(obj){  (obj.latitude_changed? || obj.latitude.blank?) && !Rails.env.test? }

  accepts_nested_attributes_for :city_banners, reject_if: :all_blank, allow_destroy: true

  default_scope { includes(:translations) }
  scope :enabled, -> { joins(:country).merge(Country.where(disabled: false)).where(disabled: false) }

  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors

  def city_image
    return false unless self.city_banners.present?
    self.city_banners.sample
  end

  def default_city_image
    ActionController::Base.helpers.asset_path('missing/defaultcity.jpg')
  end

  def english_name
    I18n.with_locale(:en) { self.name }
  end


  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def enabled?
    !self.disabled && !self.country.disabled
  end

  def slug_candidates
    [
      :name,
      [:id, :name]
    ]
  end

  def city_country
    "#{self.name}, #{self.country}"
  end

  def coordinates
    if self.latitude.present? && self.longitude.present?
      "#{ self.latitude }, #{ self.longitude }"
    else
      "0, 0"
    end
  end

  def active_businesses
    self.businesses.active
  end

  def closest_cities
    self.country.cities.where.not(id: self)
    .sort_by{ |city| distance("#{ city.latitude }, #{ city.longitude}", "#{ self.latitude }, #{ self.longitude }") }
  end

  def country_cities
    self.country.cities.enabled
  end

end
