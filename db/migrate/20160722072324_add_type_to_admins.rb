class AddTypeToAdmins < ActiveRecord::Migration[5.0]
  def change
    change_table :admins do |t|
      t.integer :role
    end
  end
end
