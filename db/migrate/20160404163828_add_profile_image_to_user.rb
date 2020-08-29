class AddProfileImageToUser < ActiveRecord::Migration[5.0]
  def change
    add_attachment :users, :profile_image
  end
end
