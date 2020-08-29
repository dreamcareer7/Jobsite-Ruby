class AddSelfAddedProjectsCounterToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :self_added_projects_count, :integer, default: 0
  end
end
