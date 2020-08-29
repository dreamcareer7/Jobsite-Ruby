require 'rails_helper'

RSpec.describe Review, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:review)).to be_valid
  end
  it "scores reliability between 0 and 5" do
    expect(FactoryGirl.build(:review, reliability: nil)).not_to be_valid
  end
  it "scores tidiness between 0 and 5" do
    expect(FactoryGirl.build(:review, tidiness: -1)).not_to be_valid
  end
  it "scores courtesy between 0 and 5" do
    expect(FactoryGirl.build(:review, courtesy: 10)).not_to be_valid
  end
  it "scores workmanship between 0 and 5" do
    expect(FactoryGirl.build(:review, workmanship: "cat")).not_to be_valid
  end
  it "scores value for money between 0 and 5" do
    expect(FactoryGirl.build(:review, value_for_money: 3)).to be_valid
  end
  it "has a user" do
    review = FactoryGirl.build_stubbed(:review)
    expect{ review.user }.not_to raise_error
  end
  it "has a business" do
    review = FactoryGirl.build_stubbed(:review)
    expect{ review.business }.not_to raise_error
  end
  it "has a project" do
    review = FactoryGirl.build_stubbed(:review)
    expect{ review.project }.not_to raise_error
  end

  describe Review, "#average_score" do
    it "finds the average score for a review" do
      review = FactoryGirl.create(:review)

      expect(review.average_score).to be_a(Float)
    end
  end

end
