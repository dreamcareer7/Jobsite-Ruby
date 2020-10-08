class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.references :user
      t.string :favoratable_type
      t.integer :favoratable_id
      t.timestamps
    end
  end
end
