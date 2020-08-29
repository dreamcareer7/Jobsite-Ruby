class AddPositionToBusinessContact < ActiveRecord::Migration[5.0]
  def change
    remove_column :business_contacts, :role, :string
    add_column :business_contacts, :position, :integer
  end
end
