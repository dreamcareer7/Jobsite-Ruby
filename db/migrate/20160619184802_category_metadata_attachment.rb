class CategoryMetadataAttachment < ActiveRecord::Migration[5.0]
  def change
    add_attachment :category_metadata, :banner
  end
end
