class AddEmailNameToAdminNotifications < ActiveRecord::Migration[5.0]
  def up
    add_column :admin_notifications, :user_email, :string
    add_column :admin_notifications, :user_name, :string
  end

  def down
    remove_column :admin_notifications, :user_email
    remove_column :admin_notifications, :user_name
  end
end
