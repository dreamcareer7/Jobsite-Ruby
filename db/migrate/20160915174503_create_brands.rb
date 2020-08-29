class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.belongs_to :business
      t.timestamps
    end
  end
end
