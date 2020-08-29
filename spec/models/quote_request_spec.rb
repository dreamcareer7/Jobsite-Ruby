require 'rails_helper'

RSpec.describe QuoteRequest, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:quote_request)).to be_valid
  end

  it "has a user" do
    expect(FactoryGirl.build(:quote_request, user_id: nil)).not_to be_valid
  end

  it "has a project" do
    expect(FactoryGirl.build(:quote_request, project_id: nil)).not_to be_valid
  end

  it "has a business" do
    expect(FactoryGirl.build(:quote_request, business_id: nil)).not_to be_valid
  end

  it "has a status" do
    expect(FactoryGirl.build(:quote_request, status: nil)).not_to be_valid
  end

  it "belongs to a user" do
    quote_request = FactoryGirl.build_stubbed(:quote_request)
    expect{ quote_request.user }.not_to raise_error
  end

  it "belongs to a project" do
    quote_request = FactoryGirl.build_stubbed(:quote_request)
    expect{ quote_request.project }.not_to raise_error
  end

  it "belongs to a business" do
    quote_request = FactoryGirl.build_stubbed(:quote_request)
    expect{ quote_request.business }.not_to raise_error
  end

  describe QuoteRequest, ".by_status" do
    it "returns a list of QuoteRequests that match a status" do
      quote_request = FactoryGirl.create(:quote_request, :pending)
      quote_request2 = FactoryGirl.create(:quote_request, :accepted)

      expect(QuoteRequest.by_status("pending")).to include(quote_request)
      expect(QuoteRequest.by_status("pending")).not_to include(quote_request2)
    end
  end

end
