require 'rails_helper'

RSpec.describe Banner, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:banner)).to be_valid
  end
  it "has a title" do
    expect(FactoryGirl.build(:banner, title: nil)).not_to be_valid
  end
  it "has many banner targets" do
    banner = FactoryGirl.build_stubbed(:banner)
    expect{ banner.banner_targets }.not_to raise_error
  end
  it "has an english image" do
    banner = FactoryGirl.build_stubbed(:banner)
    expect{ banner.image_en }.not_to raise_error
  end
  it "has an arabic image" do
    banner = FactoryGirl.build_stubbed(:banner)
    expect{ banner.image_ar }.not_to raise_error
  end
  it "has an english link" do
    banner = FactoryGirl.build_stubbed(:banner)
    expect{ banner.link_en }.not_to raise_error
  end
  it "has an arabic link" do
    banner = FactoryGirl.build_stubbed(:banner)
    expect{ banner.link_ar }.not_to raise_error
  end
  it "can be enabled" do
    banner = FactoryGirl.build_stubbed(:banner)
    expect{ banner.enabled }.not_to raise_error
  end
end
