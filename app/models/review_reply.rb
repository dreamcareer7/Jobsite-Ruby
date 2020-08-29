class ReviewReply < ApplicationRecord

  belongs_to :business
  belongs_to :review
  has_one :project, through: :review

end
