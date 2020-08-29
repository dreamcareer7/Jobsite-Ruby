class Brand < ApplicationRecord
  belongs_to :business
  has_many :brand_subsidiaries

  has_many :businesses, through: :brand_subsidiaries
end
