class AddTranslationFieldsToLocations < ActiveRecord::Migration[5.0]
  def self.up
    Location.create_translation_table!({
      street_address: :string,
    }, {
      migrate_data: true
    })
  end
  def self.down
    Location.drop_translation_table! migrate_data: true
  end
end
