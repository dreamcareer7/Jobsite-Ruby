class ProjectsMatchingBusiness < ApplicationRecord
  belongs_to :project
  belongs_to :business
end
