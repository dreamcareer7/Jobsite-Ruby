class AddFavoriteCountToGallery < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :favoratable_count, :integer, default: 0
    add_column :self_added_projects, :favoratable_count, :integer, default: 0
    add_column :businesses, :favoratable_count, :integer, default: 0
  end
end
