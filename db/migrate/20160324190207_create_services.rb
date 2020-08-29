class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name
      t.integer :sub_category_id
      t.timestamps
    end
  end
end
