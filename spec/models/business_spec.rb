require 'rails_helper'

RSpec.describe Business, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:business)).to be_valid
  end
  it "has a name" do
    expect(FactoryGirl.build(:business, name: nil)).not_to be_valid
  end
  it "has locations" do
    business = FactoryGirl.create(:business)
    expect{ business.locations }.not_to raise_error
  end
  it "has quotes" do
    business = FactoryGirl.build_stubbed(:business)
    expect{ business.quotes }.not_to raise_error
  end
  it "has services" do
    business = FactoryGirl.build_stubbed(:business)
    expect{ business.services }.not_to raise_error
  end
  it "has reviews" do
    business = FactoryGirl.build_stubbed(:business)
    expect{ business.reviews }.not_to raise_error
  end
  it "has many subscriptions" do
    business = FactoryGirl.build_stubbed(:business)
    expect{ business.subscriptions }.not_to raise_error
  end
  it "has favourites" do
    business = FactoryGirl.build_stubbed(:business)
    expect{ business.favourites }.not_to raise_error
  end

  describe Business, "#pending_projects" do
    it "returns a list of quotes that have not been accepted or denied" do
      business = FactoryGirl.create(:business, :has_pending_quotes)
      expect(business.pending_projects.count).to be > (0)
    end
  end

  describe Business, "#ongoing_projects" do
    it "returns a list of projects with accepted quotes" do
      business = FactoryGirl.create(:business, :has_accepted_quotes)
      expect(business.ongoing_projects.count).to be > (0)
    end
  end

  describe Business, "#completed_projects" do
    it "returns a list of quotes that have not been accepted or denied" do
      business = FactoryGirl.create(:business, :has_completed_projects)
      expect(business.completed_projects.count).to be >= (0)
    end
  end

  describe Business, "#average_review_score" do
    it "finds the average of all a business's reviews" do
      business = FactoryGirl.build_stubbed(:business, :has_multiple_reviews)

      expect(business.average_review_score).to be_an(Integer)
    end
  end

  describe Business, "#distance_from_user" do
    it "calculates the distance between the business and current user" do
      business = FactoryGirl.create(:business)

      expect(business.distance_from_user(City.first, "34.804783, 60.292969")).to be_a(Float)
    end
  end

  describe Business, "#set_claimed" do
    it "sets the status to claimed if a user is present, otherwise unclaimed" do
      business = FactoryGirl.create(:business)
      business2 = FactoryGirl.create(:business, :no_user)

      expect(business.claimed?).to eq(true)
      expect(business2.claimed?).to eq(false)
    end
  end

  describe Business, ".by_city" do
    it "returns a list of businesses in a given city" do
      business = FactoryGirl.create(:business)
      expect(Business.by_city(business.cities.first)).to include(business)
    end
  end

  describe Business, ".by_country" do
    it "returns a list of businesses in a given country" do
      business = FactoryGirl.create(:business)
      expect(Business.by_country(business.countries.first)).to include(business)
    end
  end

  describe Business, ".by_category" do
    it "returns a list of businesses in a given category" do
      business = FactoryGirl.create(:business)
      expect(Business.by_category(business.categories.first)).to include(business)
    end
  end

  describe Business, ".by_service" do
    it "returns a list of businesses with a specific service" do
      business = FactoryGirl.create(:business)
      expect(Business.by_service(business.services.first)).to include(business)
    end
  end

  describe Business, ".by_sub_category" do
    it "returns a list of businesses in a given sub-category" do
      business = FactoryGirl.create(:business)
      expect(Business.by_sub_category(business.sub_categories.first)).to include(business)
    end
  end

  describe Business, ".sort_by_reviews_score" do
    it "returns an array of businesses sorted by their average review score" do
      business = FactoryGirl.create(:business, :has_a_negative_review)
      business2 = FactoryGirl.create(:business, :has_a_positive_review)
      sorted_businesses = Business.sort_by_reviews_score

      expect(sorted_businesses).to be_an(Array)
      expect(sorted_businesses[0]).to eq(business2)
      expect(sorted_businesses[1]).to eq(business)

    end
  end

end
