class CreateSocialLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :social_links do |t|
      t.string :facebook
      t.string :twitter
      t.string :linkedin
      t.references :owner, polymorphic: true, index: true
    end
  end
end
