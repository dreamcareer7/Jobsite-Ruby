class CreateApplyToProjectJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :applied_to_projects do |t|
      t.integer :project_id
      t.integer :business_id
      t.timestamps
    end
  end
end
