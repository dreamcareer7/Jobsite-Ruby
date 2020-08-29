class CreateProjectTypeJoins < ActiveRecord::Migration[5.0]
  def change
    create_table :project_type_joins do |t|
      t.references :project_type
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end
  end
end
