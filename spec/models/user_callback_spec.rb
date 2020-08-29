require 'rails_helper'

RSpec.describe UserCallback, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:user_callback)).to be_valid
  end

  it "has a user id" do
    expect(FactoryGirl.build(:user_callback, user_id: nil)).not_to be_valid
  end

  it "has a business id" do
    expect(FactoryGirl.build(:user_callback, business_id: nil)).not_to be_valid
  end

  it "has a user number" do
    expect(FactoryGirl.build(:user_callback, user_number: nil)).not_to be_valid
  end

  it "belongs to a business" do
    user_callback = FactoryGirl.build_stubbed(:user_callback)
    expect{ user_callback.business }.not_to raise_error
  end

  it "belongs to a user" do
    user_callback = FactoryGirl.build_stubbed(:user_callback)
    expect{ user_callback.user }.not_to raise_error
  end

end
