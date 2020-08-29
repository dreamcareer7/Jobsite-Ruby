class AddCitiesAndCountriesToAdmins < ActiveRecord::Migration[5.0]
  def up
    # We use change_table here because, for some reason, this table was partially defined in an older migration
    change_table :admin_countries do |t|
      t.belongs_to :admin
      t.belongs_to :country
      t.remove :AdminCity
    end

    create_table :admin_cities do |t|
      t.belongs_to :admin
      t.belongs_to :city
    end
  end

  def down
    drop_table :admin_cities
  end
end
