class AddCategoryToProject < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :category, index: true
  end
end
