require 'rails_helper'

RSpec.describe Sponsor, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:sponsor)).to be_valid
  end
  it "belongs to a location" do
    expect(FactoryGirl.build(:sponsor, location_owner_id: nil)).not_to be_valid

  end
  it "belongs to a listing" do
    expect(FactoryGirl.build(:sponsor, listing_owner_id: nil)).not_to be_valid
  end
end
