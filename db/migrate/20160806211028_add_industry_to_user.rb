class AddIndustryToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :industry, :integer
    remove_column :users, :occupation
  end
end
