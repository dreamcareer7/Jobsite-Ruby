class AddTranslationTableToBusinessContact < ActiveRecord::Migration[5.0]
  def self.up
    BusinessContact.create_translation_table!({
      name: :string,
    }, {
      migrate_data: true
    })
  end
  def self.down
    BusinessContact.drop_translation_table! migrate_data: true
  end

end
