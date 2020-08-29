class BusinessService < ApplicationRecord

  validates :business, :service, presence: true

  belongs_to :service
  belongs_to :business

end
