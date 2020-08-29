class AddContactToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :contact_name, :string
    add_column :projects, :contact_email, :string
    add_column :projects, :contact_number, :string
    add_column :projects, :contact_role, :integer
  end
end
