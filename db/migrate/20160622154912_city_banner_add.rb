class CityBannerAdd < ActiveRecord::Migration[5.0]
  def change
    add_attachment :cities, :banner
  end
end
