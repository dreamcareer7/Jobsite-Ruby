class RemoveBusinessHoursFromBusiness < ActiveRecord::Migration[5.0]
  def up
    remove_column :businesses, :business_hours
  end

  def down
    add_column :businesses, :business_hours, :string
  end
end
