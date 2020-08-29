class BusinessAddApprovedBoolean < ActiveRecord::Migration[5.0]
  def up
    add_column :businesses, :approved, :boolean, default: false
  end
  def down
    remove_column :businesses, :approved, :boolean, default: false
  end
end
