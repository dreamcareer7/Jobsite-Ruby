class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :fb_omniauth_info, :string
    add_column :users, :google_omniauth_info, :string
  end
end
