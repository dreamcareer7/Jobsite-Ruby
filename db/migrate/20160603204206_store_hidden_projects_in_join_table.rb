class StoreHiddenProjectsInJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :hidden_projects do |t|
      t.belongs_to :business
      t.belongs_to :project
      t.timestamps
    end
  end
end
