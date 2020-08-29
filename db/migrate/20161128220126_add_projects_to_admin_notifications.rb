class AddProjectsToAdminNotifications < ActiveRecord::Migration[5.0]
  def change
    add_reference :admin_notifications, :project, index: true
  end
end
