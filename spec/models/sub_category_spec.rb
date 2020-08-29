require 'rails_helper'

RSpec.describe SubCategory, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:sub_category)).to be_valid
  end
  it "has a name" do
    expect(FactoryGirl.build(:sub_category, name: nil)).not_to be_valid
  end
  it "belongs to a category" do
    expect(FactoryGirl.build(:sub_category, category_id: nil)).not_to be_valid
  end
  it "has services" do
    sub_category = FactoryGirl.build_stubbed(:sub_category)
    expect{ sub_category.services }.not_to raise_error
  end
  
end
