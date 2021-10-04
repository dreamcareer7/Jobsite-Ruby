class ProjectBusiness < ApplicationRecord

  validates :project, :business, presence: true

  belongs_to :project
  belongs_to :business

  enum status: [
    :matched,
    :shortlisted,
    :interested3
  ]

end
