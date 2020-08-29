class ProjectTypeJoin < ApplicationRecord
  belongs_to :project_type
  belongs_to :owner, polymorphic: true
end
