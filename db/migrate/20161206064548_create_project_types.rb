class CreateProjectTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :project_types do |t|
      t.integer :category_type
      t.references :project
      t.references :business
    end

    reversible do |dir|
      dir.up do
        ProjectType.create_translation_table! :name => :string
      end

      dir.down do 
        ProjectType.drop_translation_table!
      end
    end
  end
end
