class AddLicenseToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :license_number, :string
  end
end
