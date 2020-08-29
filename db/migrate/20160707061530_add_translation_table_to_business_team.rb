class AddTranslationTableToBusinessTeam < ActiveRecord::Migration[5.0]
  def self.up
    TeamMember.create_translation_table!({
      name: :string,
      role: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    TeamMember.drop_translation_table! migrate_data: true
  end
end
