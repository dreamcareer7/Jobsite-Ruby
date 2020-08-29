class AddLinkToCityBanners < ActiveRecord::Migration[5.0]
  def up
    add_column :city_banners, :link, :string
  end

  def down
    remove_column :city_banners, :link
  end
end
