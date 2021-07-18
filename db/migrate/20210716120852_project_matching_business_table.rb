class ProjectMatchingBusinessTable < ActiveRecord::Migration[5.0]
  def change
    create_table :projects_matching_businesses do |t|
      t.references :project
      t.references :business
      t.boolean :automatic_match
      t.integer :order
      t.timestamps
    end
    ProjectsMatchingBusiness.delete_all
    Project.completed.each do |project|
      project.suggested_businesses.sort_by { |b| b.profile_completion }.each_with_index do |business, index|
        ProjectsMatchingBusiness.create(project_id: project.id, business_id: business.id, automatic_match: true, order: index + 1)
      end
    end
  end
end
