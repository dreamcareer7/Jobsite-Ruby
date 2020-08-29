class CreateFollow < ActiveRecord::Migration[5.0]
  def change
    create_table :follows do |t|
      t.references :user
      t.references :follow_target, polymorphic: true, index: true
      t.timestamps
    end
  end
end
