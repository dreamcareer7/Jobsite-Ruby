class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
    t.string :body
    t.integer :sending_user_id
    t.integer :receiving_user_id
    t.string :sending_user_type
    t.string :receiving_user_type
    t.boolean :read, default: false
    t.timestamps
    end
  end
end
