require 'rails_helper'

RSpec.describe SponsorLevel, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:sponsor_level)).to be_valid
  end
  it "has a level name" do
    expect(FactoryGirl.build(:sponsor_level, level_name: nil)).not_to be_valid
  end
  it "details the number of listing targets" do
    expect(FactoryGirl.build(:sponsor_level, listing_targets_count: nil)).not_to be_valid
  end
  it "details the number of location targets" do
    expect(FactoryGirl.build(:sponsor_level, location_targets_count: nil)).not_to be_valid
  end

end
