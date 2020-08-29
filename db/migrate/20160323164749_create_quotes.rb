class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.text :description
      t.integer :reference_number
      t.date :valid_until
      t.integer :approximate_duration
      t.integer :business_id

      t.timestamps
    end
  end
end
