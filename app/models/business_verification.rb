class BusinessVerification < ApplicationRecord

  validates :business, :verification, presence: true

  belongs_to :verification
  belongs_to :business

end
