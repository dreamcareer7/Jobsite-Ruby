class ChangeProjectBudgetColumn < ActiveRecord::Migration[5.0]
  def up
    change_column :projects, :budget, :string
  end

  def down
    change_column :projects, :budget, :string
  end
end
