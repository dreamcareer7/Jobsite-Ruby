class AddViewCountAndChangeToSubCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_categories, :view_count, :integer, default: 0
    add_column :sub_categories, :view_count_change, :integer, default: 0
  end
end
