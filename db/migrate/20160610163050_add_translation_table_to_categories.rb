class AddTranslationTableToCategories < ActiveRecord::Migration[5.0]

  def self.up
    Category.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    Category.drop_translation_table! migrate_data: true
  end

end
