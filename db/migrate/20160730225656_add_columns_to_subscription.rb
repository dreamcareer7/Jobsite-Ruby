class AddColumnsToSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :payment_method, :string
    add_column :subscriptions, :auto_renew, :boolean, default: false
  end
end
