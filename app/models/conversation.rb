class Conversation < ApplicationRecord
  belongs_to :user_one
  belongs_to :user_two

  has_many :messages
end
