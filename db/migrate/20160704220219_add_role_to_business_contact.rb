class AddRoleToBusinessContact < ActiveRecord::Migration[5.0]
  def change
    add_column :business_contacts, :role, :string
  end
end
