class ChangeQuoteFields < ActiveRecord::Migration[5.0]
  def up
    remove_column :quotes, :description, :string
    change_column :quotes, :reference_number, :string
    change_column :quotes, :approximate_duration, :string
    change_column :quotes, :status, :string, default: "pending"
    add_column :quotes, :introduction, :text
    add_column :quotes, :approximate_budget, :string
    add_column :quotes, :proposal, :text
  end

  def down
    add_column :quotes, :description, :string
    remove_column :quotes, :introduction, :text
    remove_column :quotes, :approximate_budget, :string
    remove_column :quotes, :proposal, :text
  end
end
