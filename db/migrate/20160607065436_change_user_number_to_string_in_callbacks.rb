class ChangeUserNumberToStringInCallbacks < ActiveRecord::Migration[5.0]
  def up
    change_column :user_callbacks, :user_number, :string
  end

  def down
    change_column :user_callbacks, :user_number, 'integer USING CAST(user_number AS integer)'
  end
end
