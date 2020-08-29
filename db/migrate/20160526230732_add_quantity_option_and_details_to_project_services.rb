class AddQuantityOptionAndDetailsToProjectServices < ActiveRecord::Migration[5.0]
  def change
    add_column :project_services, :quantity, :integer
    add_column :project_services, :option, :string
    add_column :project_services, :details, :string
  end
end
