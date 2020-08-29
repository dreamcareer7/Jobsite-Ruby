class AddLinkedinOmniauthInfoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :linkedin_omniauth_info, :string
  end
end
