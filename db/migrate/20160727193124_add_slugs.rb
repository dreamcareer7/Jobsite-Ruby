class AddSlugs < ActiveRecord::Migration[5.0]
  def change
    change_table :categories do |t|
      t.string :slug, unique: true
    end

    change_table :services do |t|
      t.string :slug, unique: true
    end

    change_table :sub_categories do |t|
      t.string :slug, unique: true
    end

    change_table :cities do |t|
      t.string :slug, unique: true
    end
  end
end
