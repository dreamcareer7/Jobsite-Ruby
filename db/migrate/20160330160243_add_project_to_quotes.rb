class AddProjectToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :project_id, :integer
  end
end
