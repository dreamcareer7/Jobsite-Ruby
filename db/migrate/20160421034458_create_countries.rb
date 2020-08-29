class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :continent
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
