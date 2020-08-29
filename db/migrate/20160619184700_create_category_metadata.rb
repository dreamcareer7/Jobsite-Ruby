class CreateCategoryMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :category_metadata do |t|
      t.string :subheadline
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end
  end
end
