class CreateFavourites < ActiveRecord::Migration[5.0]
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.integer :business_id
      t.timestamps
    end
  end
end
