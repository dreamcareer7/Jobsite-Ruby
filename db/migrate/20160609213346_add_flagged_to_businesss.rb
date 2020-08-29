class AddFlaggedToBusinesss < ActiveRecord::Migration[5.0]
  def up
    add_column :businesses, :flagged, :boolean, default: false
  end
  def down
    remove_column :businesses, :flagged, :boolean, default: false
  end
end
