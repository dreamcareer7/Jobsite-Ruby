class ConvertHoursToTime < ActiveRecord::Migration[5.0]
  def change
    change_table :hours_of_operations do |t|
      t.time :start_time
      t.time :end_time
    end
  end
end