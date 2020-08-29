class AddTranslationTableToServices < ActiveRecord::Migration[5.0]

  def self.up
    Service.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    Service.drop_translation_table! migrate_data: true
  end

end
