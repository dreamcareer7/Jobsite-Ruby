class AddTimelineTypeToProjects < ActiveRecord::Migration[5.0]
  def up
    add_column :projects, :timeline_type, :integer
  end

  def down
    remove_column :projects, :timeline_type
  end
end
