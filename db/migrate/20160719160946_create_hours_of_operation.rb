class CreateHoursOfOperation < ActiveRecord::Migration[5.0]
  def change
    create_table :hours_of_operations do |t|
      t.string :start_day
      t.string :end_day
      t.string :start_hour
      t.string :end_hour
      t.references :business
      t.references :location
      t.timestamps
    end
  end
end
