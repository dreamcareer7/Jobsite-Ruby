class RemoveUnnamedProjects < ActiveRecord::Migration[5.0]
  def change
    Project.where(title: nil).delete_all
    Project.where(category: nil).delete_all
  end
end
