class CreatePhotoGalleries < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_galleries do |t|
      t.references :owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
