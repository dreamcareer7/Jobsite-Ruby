class ProjectBatch < ApplicationRecord

  def projects
    Project.where(id: [self.project1, self.project2, self.project3])
  end

  def vacancy?
    self.attributes.values.include?(nil)
  end

  def category_present?(category)
    self.projects.any? { |project| project.category == category }
  end

  def any_pending_completion?
    self.projects.any? { |project| project.creation_status == "additional_information" }
  end

end
