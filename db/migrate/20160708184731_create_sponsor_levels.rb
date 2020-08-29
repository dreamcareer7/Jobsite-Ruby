class CreateSponsorLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :sponsor_levels do |t|
      t.string :level_name
      t.integer :listing_targets_count
      t.integer :location_targets_count
      t.timestamps
    end
  end
end
