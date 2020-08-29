class AddProjectToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :project_id, :integer
  end
end
