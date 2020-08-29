class AddHiddenToSubCatsAndServices < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_categories, :hidden, :boolean, default: false
    add_column :services, :hidden, :boolean, default: false
  end
end
