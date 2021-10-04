class ProjectBusiness < ActiveRecord::Migration[5.0]
  def change
    create_table :project_businesses do |t|
      t.references :project
      t.string :business
      t.integer :status
      t.timestamps
    end
  end
end
