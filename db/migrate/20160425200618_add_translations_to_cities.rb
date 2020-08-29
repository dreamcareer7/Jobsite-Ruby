class AddTranslationsToCities < ActiveRecord::Migration[5.0]

  def up
    City.create_translation_table!({ name: :string }, { migrate_data: true })
  end

  def down
    City.drop_translation_table! migrate_data: true
  end

end
