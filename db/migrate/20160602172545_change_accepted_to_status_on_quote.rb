class ChangeAcceptedToStatusOnQuote < ActiveRecord::Migration[5.0]
  def up
    remove_column :quotes, :accepted, :boolean
    add_column :quotes, :status, :string
  end
  def down
    remove_column :quotes, :status, :string
    add_column :quotes, :accepted, :boolean
  end
end
