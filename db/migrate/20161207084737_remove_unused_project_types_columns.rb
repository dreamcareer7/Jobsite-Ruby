class RemoveUnusedProjectTypesColumns < ActiveRecord::Migration[5.0]
  def up
    remove_column :project_types, :business_id
    remove_column :project_types, :project_id
  end

  def down
    add_column :project_types, :business_id, :integer
    add_column :project_types, :project_id, :integer
  end
end
