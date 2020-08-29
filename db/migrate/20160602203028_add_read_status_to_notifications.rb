class AddReadStatusToNotifications < ActiveRecord::Migration[5.0]
  def up
    add_column :notifications, :read, :boolean, default: false
  end
  def down
    remove_column :notifications, :read, :boolean, default: false
  end
end
