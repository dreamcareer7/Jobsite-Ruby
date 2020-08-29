class AddDefaultProfileToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default_profile, :integer
  end
end
