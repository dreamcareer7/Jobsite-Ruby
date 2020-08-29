require 'rails_helper'

RSpec.describe Service, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:service)).to be_valid
  end
  it "has a name" do
    expect(FactoryGirl.build(:service, name: nil)).not_to be_valid
  end
  it "belongs to a sub category" do
    service = FactoryGirl.build_stubbed(:service)
    expect{ service.sub_category }.not_to raise_error
  end
  it "it belongs to a category" do
    service = FactoryGirl.build_stubbed(:service)
    expect{ service.category }.not_to raise_error
  end
  it "it has businesses" do
    service = FactoryGirl.build_stubbed(:service)
    expect{ service.businesses }.not_to raise_error
  end

end
