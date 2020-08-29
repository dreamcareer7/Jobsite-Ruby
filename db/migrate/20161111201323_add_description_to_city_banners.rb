class AddDescriptionToCityBanners < ActiveRecord::Migration[5.0]
  def change
    reversible do |rev|
      rev.up do
        add_column :city_banners, :description, :string
        CityBanner.create_translation_table!({
          description: :string
        }, { migrate_date: :true })
      end

      rev.down do
        CityBanner.drop_translation_table! migrate_date: :true
        remove_column :city_banners, :description
      end
    end
  end
end
