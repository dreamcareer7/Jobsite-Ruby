class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.text :description
      t.string :telephone
      t.string :fax
      t.string :email
      t.string :website
      t.integer :number_of_employees
      t.integer :years_of_establishment
      t.integer :number_of_branches
      t.string :insurance_coverage
      t.string :legal_status
      t.integer :user_id

      t.timestamps
    end
  end
end
