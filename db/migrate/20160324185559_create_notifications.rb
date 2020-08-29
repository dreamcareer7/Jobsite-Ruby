class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :body
      t.integer :project_id
      t.integer :quote_id
      t.integer :sending_user_id
      t.integer :receiving_user_id

      t.timestamps
    end
  end
end
