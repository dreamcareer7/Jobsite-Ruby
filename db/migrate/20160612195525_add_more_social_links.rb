class AddMoreSocialLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :social_links, :youtube, :string
    add_column :social_links, :instagram, :string
    add_column :social_links, :google_plus, :string
  end
end
