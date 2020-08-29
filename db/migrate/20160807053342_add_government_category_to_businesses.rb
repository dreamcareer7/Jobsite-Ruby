class AddGovernmentCategoryToBusinesses < ActiveRecord::Migration[5.0]
  def change
    change_table :businesses do |t|
      t.boolean :government
    end
  end
end
