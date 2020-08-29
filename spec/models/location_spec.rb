require 'rails_helper'

RSpec.describe Location, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:location)).to be_valid
  end

  it "belongs to a city" do
    expect(FactoryGirl.build(:location, city_id: nil)).not_to be_valid
  end

  it "has a country through its city" do
    location = FactoryGirl.build_stubbed(:location)
    expect{ location.country }.not_to raise_error
  end

end
