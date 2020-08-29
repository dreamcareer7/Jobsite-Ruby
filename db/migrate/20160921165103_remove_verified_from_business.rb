class RemoveVerifiedFromBusiness < ActiveRecord::Migration[5.0]
  def up
    remove_column :businesses, :verified
  end

  def down
    add_column :businesses, :verified, :boolean
  end
end
