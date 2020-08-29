require 'rails_helper'

RSpec.describe Subscription, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end
  it "has a type" do
    expect(FactoryGirl.build(:subscription, subscription_type: nil)).not_to be_valid
  end
  it "has a user" do
    subscription = FactoryGirl.build_stubbed(:subscription)
    expect{ subscription.user }.not_to raise_error
  end

end
