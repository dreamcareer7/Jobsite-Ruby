class CategoryMetdataTranslationCreate < ActiveRecord::Migration[5.0]
  def self.up
    CategoryMetadata.create_translation_table!({
      subheadline: :string
    }, {
      migrate_data: true
    })

  end

  def self.down
    CategoryMetadata.drop_translation_table! migrate_data: true
  end
end
