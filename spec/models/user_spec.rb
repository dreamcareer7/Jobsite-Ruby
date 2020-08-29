require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end
  it "has a name" do
    expect(FactoryGirl.build(:user, name: nil)).not_to be_valid
  end
  it "has an email" do
    expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
  end
  it "has a password" do
    expect(FactoryGirl.build(:user, password: nil)).not_to be_valid
  end
  it "has a many subscriptions" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.subscriptions }.not_to raise_error
  end
  it "has a location" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.location }.not_to raise_error
  end
  it "has businesses" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.businesses }.not_to raise_error
  end
  it "has projects" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.projects }.not_to raise_error
  end
  it "has reviews" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.reviews }.not_to raise_error
  end
  it "has favourites" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.favourites }.not_to raise_error
  end
  it "has incoming notifications" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.incoming_notifications }.not_to raise_error
  end
  it "has outgoing notifications" do
    user = FactoryGirl.build_stubbed(:user)
    expect{ user.outgoing_notifications }.not_to raise_error
  end

  describe User, "#quote_requests_pending_two_days?" do
    it "returns true if a user has pending quote requests sent over two days ago" do
      user = FactoryGirl.create(:user, :has_quote_request_available_for_refund)
      expect(user.quote_requests_pending_two_days?).to be_truthy
    end
  end

  describe User, ".with_businesses" do
    it "returns a list of users with businesses" do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user, :has_standard_business)

      expect(User.with_businesses).to include(user2)
      expect(User.with_businesses).not_to include(user)
    end
  end

  describe User, ".without_businesses" do
    it "returns a list of users with businesses" do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user, :has_standard_business)

      expect(User.without_businesses).to include(user)
      expect(User.without_businesses).not_to include(user2)
    end
  end

end
