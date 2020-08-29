class AddBusinessToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :business_id, :integer
  end
end
