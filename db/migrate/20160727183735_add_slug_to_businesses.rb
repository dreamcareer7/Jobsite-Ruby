class AddSlugToBusinesses < ActiveRecord::Migration[5.0]
  def change
    change_table :businesses do |t|
      t.string :slug
    end
  end
end
