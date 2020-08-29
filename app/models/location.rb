class Location < ApplicationRecord

  validates :city, presence: true

  validates_associated :owner

  belongs_to :city

  belongs_to :owner, polymorphic: true

  has_one :country, through: :city
  has_one :hours_of_operation

  geocoded_by :street_address, if: -> (obj){ obj.street_address.present? }

  after_validation :geocode, if: ->(obj){ obj.city.present? && obj.latitude.blank? && !Rails.env.test? }

  translates :location_type, :description, :street_address, fallbacks_for_empty_translations: true
  globalize_accessors

  attr_accessor :country_for_select

  def city_country
    self.city.present? && self.country.present? ? "#{self.city.name}, #{self.country.name}" : ""
  end

  def coords_to_a
    [self.latitude, self.longitude]
  end

  class << self

    def all_for_city(city)
      Location.where(city_id: city)
    end

    def by_city(city)
      locations = Location.where(city_id: city)

      if locations.count > 1
        return locations.where(location_type: "Headquarters").first || locations.first
      else
        return locations.first
      end
    end

  end

end
