class CreateBusinessVerifications < ActiveRecord::Migration[5.0]
  def change
    create_table :business_verifications do |t|
    t.integer  "business_id"
    t.integer  "verification_id"

    t.timestamps
    end
  end
end
