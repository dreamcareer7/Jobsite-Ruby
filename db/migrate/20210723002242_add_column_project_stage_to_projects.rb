class AddColumnProjectStageToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :project_stage, :integer
  end
end
