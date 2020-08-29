class AddEnumForProjectBudget < ActiveRecord::Migration[5.0]
  def up
    add_column :projects, :project_budget, :integer
    remove_column :projects, :budget
  end

  def down
    remove_column :projects, :project_budget
    add_column :projects, :budget, :string
  end
end
