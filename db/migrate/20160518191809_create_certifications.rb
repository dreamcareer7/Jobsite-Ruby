class CreateCertifications < ActiveRecord::Migration[5.0]
  def change
    create_table :certifications do |t|
      t.string :name
      t.attachment :logo
      t.integer :business_id
    end
  end
end
