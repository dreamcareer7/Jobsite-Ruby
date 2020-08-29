class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :status, default: "new"
      t.string :creation_status
      t.integer :budget
      t.boolean :historical_structure
      t.string :location_type
      t.text :service_required, array: true, default: []
      t.integer :user_id

      t.timestamps
    end
  end
end
