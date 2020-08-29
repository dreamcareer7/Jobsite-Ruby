class CreateQuoteRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :quote_requests do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :business_id
      t.string :status, default: "pending"
      t.timestamps
    end
  end
end
