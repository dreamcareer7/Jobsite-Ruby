class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.integer :city_id
      t.integer :zip
      t.string :po_box
      t.string :street_address
      t.string :owner_type
      t.integer :owner_id
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
