class AddReferenceNumberToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :reference_number, :string
  end
end
