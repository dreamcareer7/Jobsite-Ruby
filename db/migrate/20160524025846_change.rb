class Change < ActiveRecord::Migration[5.0]
  def change
    remove_column :businesses, :status, :string
    add_column :businesses, :verified, :boolean
  end
end
