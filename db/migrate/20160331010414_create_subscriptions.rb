class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :subscription_type
      t.integer :user_id
      t.integer :business_id
      t.timestamps
    end
  end
end
