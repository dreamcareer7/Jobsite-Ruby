class CreateShortlistForProjectJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :shortlists do |t|
      t.integer :project_id
      t.integer :business_id
      t.timestamps
    end
  end
end
