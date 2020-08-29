class AddTranslationTableToSubCategories < ActiveRecord::Migration[5.0]

  def self.up
    SubCategory.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    SubCategory.drop_translation_table! migrate_data: true
  end

end
