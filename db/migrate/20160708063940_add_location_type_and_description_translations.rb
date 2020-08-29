class AddLocationTypeAndDescriptionTranslations < ActiveRecord::Migration[5.0]
  def up
    Location.add_translation_fields! location_type: :string
    Location.add_translation_fields! description: :text
  end

  def down
    remove_column :location_translations, :location_type
    remove_column :location_translations, :description
  end
end
