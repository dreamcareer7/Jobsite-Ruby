class AddBusinessHoursToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :business_hours, :string
  end
end
