class CreateAdminNotification < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_notifications do |t|
      t.integer :notification_type
      t.text :content
      t.string :page_link
      t.string :user_number
      t.references :user
      t.references :business
      t.boolean :resolved, default: false
      t.timestamps
    end
  end
end
