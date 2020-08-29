class StoreProjectServicesInJoinTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :service_required, :text, default: [], array: true

    create_table :project_services do |t|
      t.belongs_to :project
      t.belongs_to :service
    end
  end
end
