class ConvertBudgetManagedToRange < ActiveRecord::Migration[5.0]
  def change
    change_table :businesses do |t|
      t.integer :min_budget
      t.integer :max_budget
    end
  end
end
