class AddReferenceNumberToProjects < ActiveRecord::Migration[5.0]
  def up
    add_column :projects, :reference_number, :string
  end
  def down
    remove_column :projects, :reference_number
  end
end
