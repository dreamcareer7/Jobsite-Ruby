class VerificationsTranslationsCreate < ActiveRecord::Migration[5.0]
  def self.up
    Verification.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })

  end

  def self.down
    Verification.drop_translation_table! migrate_data: true
  end
end