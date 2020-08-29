class AddShiftAndWeekPeriodToHoursOfOperation < ActiveRecord::Migration[5.0]
  def change
    add_column :hours_of_operations, :shift_one_start, :time
    add_column :hours_of_operations, :shift_one_end, :time
    add_column :hours_of_operations, :shift_two_start, :time
    add_column :hours_of_operations, :shift_two_end, :time
    add_column :hours_of_operations, :week_period, :integer
  end
end
