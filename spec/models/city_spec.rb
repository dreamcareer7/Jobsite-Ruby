require 'rails_helper'

RSpec.describe City, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:city)).to be_valid
  end

  it "has a name" do
    expect(FactoryGirl.build(:city, name: nil)).not_to be_valid
  end

  it "belongs to a country" do
    expect(FactoryGirl.build(:city, country_id: nil)).not_to be_valid
  end

end
