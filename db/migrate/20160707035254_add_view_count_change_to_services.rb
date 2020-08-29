class AddViewCountChangeToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :view_count_change, :integer, default: 0
  end
end
