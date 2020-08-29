class AddCurrencyTypeToProjects < ActiveRecord::Migration[5.0]
  def up
    add_column :projects, :currency_type, :integer
  end

  def down
    remove_column :projects, :currency_type
  end
end
