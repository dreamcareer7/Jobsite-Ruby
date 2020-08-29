class CreateSponsors < ActiveRecord::Migration[5.0]
  def change
    create_table :sponsors do |t|
      t.references :location_owner, polymorphic: true, index: true
      t.references :listing_owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
