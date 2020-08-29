require 'rails_helper'

RSpec.describe Notification, type: :model do

  it "has a sender" do
    expect(FactoryGirl.build(:notification, sending_user_id: nil)).not_to be_valid
  end
  it "has a sender user type" do
    expect(FactoryGirl.build(:notification, sending_user_type: nil)).not_to be_valid
  end
  it "has a receiver" do
    expect(FactoryGirl.build(:notification, receiving_user_id: nil)).not_to be_valid
  end
  it "has a receiver user type" do
    expect(FactoryGirl.build(:notification, receiving_user_type: nil)).not_to be_valid
  end

  describe Notification, "#by_type" do
    it "returns notifications of a given type"
  end

end
