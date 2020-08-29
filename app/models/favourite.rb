class Favourite < ApplicationRecord

  validates :user, :business, presence: true
  validates_uniqueness_of :user_id, scope: :business_id

  belongs_to :user
  belongs_to :business

end
