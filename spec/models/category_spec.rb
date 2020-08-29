require 'rails_helper'

RSpec.describe Category, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:category)).to be_valid
  end
  it "has a name" do
    expect(FactoryGirl.build(:category, name: nil)).not_to be_valid
  end
  it "has sub categories" do
    category = FactoryGirl.build_stubbed(:category)
    expect{ category.sub_categories }.not_to raise_error
  end

end
