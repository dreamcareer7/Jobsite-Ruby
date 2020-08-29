class AddProfileCompletionPercentageToBusiness < ActiveRecord::Migration[5.0]
  def up
    add_column :businesses, :profile_completion, :float, default: 0
  end

  def down
    remove_column :businesses, :profile_completion
  end
end
