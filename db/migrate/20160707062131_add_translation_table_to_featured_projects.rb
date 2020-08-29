class AddTranslationTableToFeaturedProjects < ActiveRecord::Migration[5.0]
  def self.up
    SelfAddedProject.create_translation_table!({
      title: :string,
      description: :text
    }, {
      migrate_data: true
    })
  end
  def self.down
    SelfAddedProject.drop_translation_table! migrate_data: true
  end
end
