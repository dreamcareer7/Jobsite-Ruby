require 'rails_helper'

RSpec.describe Country, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:country)).to be_valid
  end

  it "has a name" do
    expect(FactoryGirl.build(:country, name: nil)).not_to be_valid
  end

end
