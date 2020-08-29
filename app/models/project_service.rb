class ProjectService < ApplicationRecord

  validates :project, :service, presence: true

  belongs_to :project
  belongs_to :service

  has_one :sub_category, through: :service
  has_one :category, through: :service

end
