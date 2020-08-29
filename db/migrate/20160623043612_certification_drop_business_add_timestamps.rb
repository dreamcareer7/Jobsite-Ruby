class CertificationDropBusinessAddTimestamps < ActiveRecord::Migration[5.0]
  def up
  	remove_column :certifications, :business_id
	add_column :certifications, :created_at, :datetime
    add_column :certifications, :updated_at, :datetime
  end
  def down
    add_column :certifications, :business_id, :integer
	remove_column :certifications, :created_at
    remove_column :certifications, :updated_at
  end
end
