class UserCallback < ApplicationRecord

  validates :user, :business, :user_number, presence: true

  belongs_to :business
  belongs_to :user
end
