class AddLocationClassToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :location_class, :integer
  end
end
