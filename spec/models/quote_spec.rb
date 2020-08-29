require 'rails_helper'

RSpec.describe Quote, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:quote)).to be_valid
  end
  it "has a proposal" do
    expect(FactoryGirl.build(:quote, proposal: nil)).not_to be_valid
  end
  it "has an approximate duration" do
    expect(FactoryGirl.build(:quote, approximate_duration: nil)).not_to be_valid
  end
  it "belongs to a business" do
    quote = FactoryGirl.build_stubbed(:quote)
    expect{ quote.business }.not_to raise_error
  end
  it "belongs to a project" do
    quote = FactoryGirl.build_stubbed(:quote)
    expect{ quote.project }.not_to raise_error
  end

  describe Quote, "#submit_quote" do
    it "sends a notification to a project owner" do
      user = FactoryGirl.create(:user, :has_projects)
      quote = FactoryGirl.create(:quote)
      project = user.projects.first
      quote.project_id = project.id

      quote.submit_quote

      expect(user.incoming_notifications.count).to eq(1)
    end

    it "it updates the project with the quote" do
      user = FactoryGirl.create(:user, :has_projects)
      quote = FactoryGirl.create(:quote)
      project = user.projects.first
      quote.project_id = project.id
      quote.save

      quote.submit_quote

      expect(quote.project.quotes.count).to eq(1)
    end
  end

  describe Quote, "#update_status" do
    it "upates the status of the quote" do
      quote = FactoryGirl.create(:quote)

      quote.update_status("shortlist")

      expect(quote.status).to eq("shortlist")
    end
  end

end
