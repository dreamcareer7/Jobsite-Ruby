class BusinessAddDisabledBoolean < ActiveRecord::Migration[5.0]
  def up
    add_column :businesses, :disabled, :boolean, default: false
  end
  def down
    remove_column :businesses, :disabled, :boolean, default: false
  end
end
