class AddTimestampsToSelfAddedProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :self_added_projects, :created_at, :datetime
    add_column :self_added_projects, :updated_at, :datetime
  end
end
