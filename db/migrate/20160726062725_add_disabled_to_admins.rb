class AddDisabledToAdmins < ActiveRecord::Migration[5.0]
  def change
    change_table :admins do |t|
      t.boolean :disabled, default: false
    end
  end
end
