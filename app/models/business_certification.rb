class BusinessCertification < ApplicationRecord

  validates :business, :certification, presence: true

  belongs_to :certification
  belongs_to :business

end
