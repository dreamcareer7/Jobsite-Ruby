class CreateCallbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_callbacks do |t|
      t.integer :user_id
      t.integer :business_id
      t.integer :user_number
      t.timestamps
    end
  end
end
