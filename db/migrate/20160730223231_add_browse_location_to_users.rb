class AddBrowseLocationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :browse_location, :integer
  end
end
