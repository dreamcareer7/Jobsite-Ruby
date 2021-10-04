class AddColumnDescriptionToCategories < ActiveRecord::Migration[5.0]
  def up
    CategoryMetadata.add_translation_fields! description: :text
  end

  def down
    remove_column :category_metadatum_translations, :description
  end
end
