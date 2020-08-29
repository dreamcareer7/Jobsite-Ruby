class AddPrequalificationToSocialLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :social_links, :prequalification, :string
  end
end
