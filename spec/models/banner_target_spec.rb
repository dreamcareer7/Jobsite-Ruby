require 'rails_helper'

RSpec.describe BannerTarget, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:banner_target)).to be_valid
  end
  it "has belongs to a banner" do
    banner_target = FactoryGirl.build_stubbed(:banner_target)
    expect{ banner_target.banner }.not_to raise_error
  end
  it "refers to a location" do
    banner_target = FactoryGirl.build_stubbed(:banner_target)
    expect{ banner_target.target_location }.not_to raise_error
  end
  it "refers to a listing type" do
    banner_target = FactoryGirl.build_stubbed(:banner_target)
    expect{ banner_target.target_listing }.not_to raise_error
  end
end
