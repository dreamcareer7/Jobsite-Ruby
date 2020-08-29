class AddViewCountCacheToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :view_count, :integer, default: 0
  end
end
