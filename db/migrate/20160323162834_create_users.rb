class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :gender
      t.integer :age
      t.date :birthday
      t.string :nationality
      t.string :occupation
      t.string :mobile_number

      t.timestamps
    end
  end
end
