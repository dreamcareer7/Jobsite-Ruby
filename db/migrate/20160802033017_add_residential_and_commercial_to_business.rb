class AddResidentialAndCommercialToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :residential, :boolean, default: false
    add_column :businesses, :commercial, :boolean, default: false
  end
end
