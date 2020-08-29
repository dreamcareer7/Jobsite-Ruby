class AddRankingToBusinesses < ActiveRecord::Migration[5.0]
  def change
    change_table :businesses do |t|
      t.float :cached_ranking
    end
  end
end
