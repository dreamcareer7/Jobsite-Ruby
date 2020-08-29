require 'rails_helper'

RSpec.describe BusinessService, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:business_service)).to be_valid
  end

  it "has a business id" do
    expect(FactoryGirl.build(:business_service, business_id: nil)).not_to be_valid
  end

  it "has a service id" do
    expect(FactoryGirl.build(:business_service, service_id: nil)).not_to be_valid
  end

  it "belongs to a business" do
    business_service = FactoryGirl.build_stubbed(:business_service)
    expect{ business_service.business }.not_to raise_error
  end
  it "belongs to a service" do
    business_service = FactoryGirl.build_stubbed(:business_service)
    expect{ business_service.service }.not_to raise_error
  end

end
