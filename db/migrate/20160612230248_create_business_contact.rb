class CreateBusinessContact < ActiveRecord::Migration[5.0]
  def change
    create_table :business_contacts do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.attachment :profile_image
      t.references :business
    end
  end
end
