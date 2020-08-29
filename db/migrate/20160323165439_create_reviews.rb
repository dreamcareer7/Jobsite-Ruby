class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :reliability
      t.integer :tidiness
      t.integer :courtesy
      t.integer :workmanship
      t.integer :value_for_money
      t.text :comment
      t.boolean :recommended
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
