class CreateBrandSubsidiaries < ActiveRecord::Migration[5.0]
  def change
    create_table :brand_subsidiaries do |t|
      t.belongs_to :business
      t.belongs_to :brand
      t.timestamps
    end
  end
end
