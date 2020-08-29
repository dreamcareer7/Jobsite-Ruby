class AddNumberProjectsCompletedToBusinesses < ActiveRecord::Migration[5.0]
  def change
    change_table :businesses do |t|
      t.integer :nb_projects_completed
    end
  end
end
