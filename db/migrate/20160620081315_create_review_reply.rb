class CreateReviewReply < ActiveRecord::Migration[5.0]
  def change
    create_table :review_replies do |t|
      t.references :business
      t.references :review
      t.text :body
      t.timestamps
    end
  end
end
