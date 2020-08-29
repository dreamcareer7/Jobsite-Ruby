class JoinProjectsInBatchTable < ActiveRecord::Migration[5.0]
  def change
    create_table :project_batches do |t|
      t.integer :project1
      t.integer :project2
      t.integer :project3
      t.timestamps
    end
  end
end
