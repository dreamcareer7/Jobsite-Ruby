class AddProfileImageToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_attachment :businesses, :profile_image
  end
end
