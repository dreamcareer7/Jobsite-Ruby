class AddDisabledToSubcatServiceCityCountry < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_categories, :disabled, :boolean, default: false
    add_column :services, :disabled, :boolean, default: false
    add_column :countries, :disabled, :boolean, default: false
    add_column :cities, :disabled, :boolean, default: false
  end
end
