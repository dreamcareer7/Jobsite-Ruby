class AddDisabledToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.boolean :disabled, default: false
    end
  end
end
