class CreateConversationJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.integer :user_one_id
      t.string :user_one_type
      t.integer :user_two_id
      t.string :user_two_type
    end
  end
end
