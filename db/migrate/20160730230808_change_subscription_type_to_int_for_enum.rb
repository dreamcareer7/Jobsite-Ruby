class ChangeSubscriptionTypeToIntForEnum < ActiveRecord::Migration[5.0]
  def up
    change_column :subscriptions, :subscription_type, 'integer USING CAST(subscription_type AS integer)'
  end

  def down
    change_column :subscriptions, :subscription_type, :string
  end
end
