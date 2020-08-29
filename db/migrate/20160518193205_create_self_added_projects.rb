class CreateSelfAddedProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :self_added_projects do |t|
      t.string :title
      t.text :description
      t.attachment :image_one
      t.attachment :image_two
      t.attachment :image_three
      t.string :video_link
      t.integer :business_id
    end
  end
end
