class AddTranslationTableToBusinesses < ActiveRecord::Migration[5.0]

  def self.up
    Business.create_translation_table!({
      name: :string,
      description: :text,
      insurance_coverage: :string,
      business_hours: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    Business.drop_translation_table! migrate_data: true
  end

end
