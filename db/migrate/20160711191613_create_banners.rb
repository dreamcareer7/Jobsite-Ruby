class CreateBanners < ActiveRecord::Migration[5.0]
  def change
    create_table :banners do |t|
      t.string :title
      t.string :banner_type
      t.date :start_date
      t.date :end_date
      t.attachment :image_en
      t.attachment :image_ar
      t.string :link_en
      t.string :link_ar
      t.boolean :enabled, default: false
      t.timestamps
    end
  end
end
