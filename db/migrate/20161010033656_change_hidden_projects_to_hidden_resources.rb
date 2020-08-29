class ChangeHiddenProjectsToHiddenResources < ActiveRecord::Migration[5.0]
  def  self.up
    rename_table :hidden_projects, :hidden_resources
  end 
  def self.down
    rename_table :hidden_resources, :hidden_projects
  end
end
