class AddUserTypesToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :sending_user_type, :string
    add_column :notifications, :receiving_user_type, :string
  end
end
