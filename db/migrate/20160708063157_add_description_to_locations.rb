class AddDescriptionToLocations < ActiveRecord::Migration[5.0]
  def up
    add_column :locations, :description, :text
    add_column :locations, :location_type, :string
    remove_column :locations, :name
  end
  def down
    remove_column :locations, :description
    remove_column :locations, :location_type
    add_column :locations, :name, :string
  end
end
