class AddEmailToAvailableTranslationsOnBusiness < ActiveRecord::Migration[5.0]
  def up
    Business.add_translation_fields! email: :string
  end

  def down
    remove_column :business_translations, :email
  end
end
