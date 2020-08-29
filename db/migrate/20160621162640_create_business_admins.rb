class CreateBusinessAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :business_admins do |t|
      t.integer :admin_id
      t.integer :business_id
      t.string :context
      t.timestamps
    end
  end
end
