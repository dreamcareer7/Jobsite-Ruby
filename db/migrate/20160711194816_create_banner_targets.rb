class CreateBannerTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :banner_targets do |t|
      t.integer :target_listing_id
      t.string :target_listing_type
      t.integer :target_location_id
      t.string :target_location_type
      t.references :banner
      t.timestamps
    end
  end
end
