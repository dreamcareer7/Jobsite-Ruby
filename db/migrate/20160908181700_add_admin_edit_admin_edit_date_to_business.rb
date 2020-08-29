class AddAdminEditAdminEditDateToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :admin_editor, :integer
    add_column :businesses, :admin_edit_date, :datetime
  end
end
