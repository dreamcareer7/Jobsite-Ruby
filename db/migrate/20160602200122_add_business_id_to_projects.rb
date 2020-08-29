class AddBusinessIdToProjects < ActiveRecord::Migration[5.0]
  def up
    add_column :projects, :business_id, :integer
  end
  def down
    remove_column :projects, :business_id, :integer
  end
end
