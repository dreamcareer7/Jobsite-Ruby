class AddAmountPaidToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :amount_paid, :string
  end
end
