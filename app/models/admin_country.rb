class AdminCountry < ApplicationRecord
  belongs_to :admin
  belongs_to :country
end
