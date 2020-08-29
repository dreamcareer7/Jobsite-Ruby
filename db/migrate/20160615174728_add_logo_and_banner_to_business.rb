class AddLogoAndBannerToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_attachment :businesses, :logo
    add_attachment :businesses, :banner
  end
end
