class AddBusinessIdToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :business_id, :integer
  end
end
