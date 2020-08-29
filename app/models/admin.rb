class Admin < ApplicationRecord
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  has_many :business_admins
  has_many :businesses, through: :business_admins

  has_many :admin_countries
  has_many :countries, through: :admin_countries
  has_many :country_cities, through: :countries, source: :cities

  has_many :admin_cities
  has_many :cities, through: :admin_cities

  enum role: [ :superadmin, :moderator, :sales, :data_manager ]

  def accessible_city_ids
    #add nil to array so cities with no location are shown
    return City.ids.push(nil) if cities.empty? && country_cities.empty?
    (country_cities.ids + cities.ids).uniq
  end
end
