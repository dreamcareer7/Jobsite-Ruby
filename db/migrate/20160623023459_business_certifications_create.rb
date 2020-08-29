class BusinessCertificationsCreate < ActiveRecord::Migration[5.0]
  def change
    create_table :business_certifications do |t|
    t.integer  "business_id"
    t.integer  "certification_id"
    t.timestamps
	end
  end
end
