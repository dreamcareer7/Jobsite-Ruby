class Shortlist < ApplicationRecord
  belongs_to :business
  belongs_to :project

  validates_uniqueness_of :business_id, scope: :project_id

end
