class Country < ApplicationRecord

  validates :name, presence: true

  has_one :sponsor, as: :location_owner

  has_many :cities
  has_many :locations, through: :cities
  has_many :businesses, through: :cities
  has_many :users, through: :locations, source: :owner, source_type: 'User'
  has_many :certifications

  translates :name, :continent, fallbacks_for_empty_translations: true
  globalize_accessors

  scope :enabled, -> { where(disabled: false) }

  def active_businesses_count
    self.cities.reduce(0){ |count, city| count += city.active_businesses.count }
  end

end
