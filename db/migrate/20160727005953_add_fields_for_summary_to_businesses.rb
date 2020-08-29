class AddFieldsForSummaryToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :business_type, :integer
    add_column :businesses, :business_class, :integer
    add_column :businesses, :service_area, :integer
    add_column :businesses, :project_size, :integer
    add_column :businesses, :budgets_managed, :integer
  end
end
