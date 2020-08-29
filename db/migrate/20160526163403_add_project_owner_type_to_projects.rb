class AddProjectOwnerTypeToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :project_owner_type, :string
  end
end
