class CreateCityBanners < ActiveRecord::Migration[5.0]
  def change
    create_table :city_banners do |t|
      t.references :city
      t.attachment :image
      t.timestamps
    end
  end
end
