class AddStatusToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :status, :string
  end
end
