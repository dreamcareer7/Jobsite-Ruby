require 'rails_helper'

RSpec.describe Favourite, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:favourite)).to be_valid
  end
  it "has a user" do
    expect(FactoryGirl.build(:favourite, user_id: nil)).not_to be_valid
  end
  it "has a business" do
    expect(FactoryGirl.build(:favourite, business_id: nil)).not_to be_valid
  end
  it "belongs to a user" do
    notification = FactoryGirl.build_stubbed(:favourite)
    expect{ notification.user }.not_to raise_error
  end
  it "has one business" do
    notification = FactoryGirl.build_stubbed(:favourite)
    expect{ notification.business }.not_to raise_error
  end

end
