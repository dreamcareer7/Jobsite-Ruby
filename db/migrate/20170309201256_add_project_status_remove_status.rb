class AddProjectStatusRemoveStatus < ActiveRecord::Migration[5.0]
  def up
    add_column :projects, :project_status, :integer, default: Project.project_statuses[:new_project]
    remove_column :projects, :status
  end

  def down
    add_column :projects, :status, :string
    remove_column :projects, :project_status
  end
end
