class AddReviewCountToBusinesses < ActiveRecord::Migration[5.0]
  def up
    add_column :businesses, :reviews_count, :integer, default: 0
  end
  def down
    remove_column :businesses, :reviews_count, :integer
  end
end
