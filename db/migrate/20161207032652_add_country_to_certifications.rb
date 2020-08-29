class AddCountryToCertifications < ActiveRecord::Migration[5.0]
  def up
    add_reference :certifications, :country, index: true
  end
  def down
    remove_reference :certifications, :country
  end
end
