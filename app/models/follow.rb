class Follow < ApplicationRecord

  validates :user, :follow_target, presence: true

  belongs_to :user
  belongs_to :follow_target, polymorphic: true

end

