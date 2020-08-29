class CreateAdminCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_countries do |t|
      t.string :AdminCity

      t.timestamps
    end
  end
end
