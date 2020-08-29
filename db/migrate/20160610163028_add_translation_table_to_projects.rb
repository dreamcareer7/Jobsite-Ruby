class AddTranslationTableToProjects < ActiveRecord::Migration[5.0]

  def self.up
    Project.create_translation_table!({
      title: :string,
      description: :text,
      location_type: :string,
      project_owner_type: :string
    }, {
      migrate_data: true
    })
  end
  def self.down
    Project.drop_translation_table! migrate_data: true
  end

end
