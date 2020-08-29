class CertificationsTranslationsCreate < ActiveRecord::Migration[5.0]
  def self.up
    Certification.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })

  end

  def self.down
    Certification.drop_translation_table! migrate_data: true
  end

end
