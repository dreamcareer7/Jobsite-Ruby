require 'rails_helper'

RSpec.describe Project, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:project)).to be_valid
  end
  it "has a title" do
    expect(FactoryGirl.build(:project, title: nil, creation_status: 'active')).not_to be_valid
  end
  it "has a description" do
    expect(FactoryGirl.build(:project, description: nil, creation_status: 'active')).not_to be_valid
  end
  it "has a start date" do
    expect(FactoryGirl.build(:project, start_date: nil, creation_status: 'active')).not_to be_valid
  end
  it "has a end date" do
    expect(FactoryGirl.build(:project, end_date: nil, creation_status: 'active')).not_to be_valid
  end
  it "it belongs to a user" do
    expect(FactoryGirl.build(:project, user_id: nil, creation_status: 'active')).not_to be_valid
  end
  it "has a review" do
    project = FactoryGirl.build_stubbed(:project)
    expect{ project.review }.not_to raise_error
  end
  it "has a quotes" do
    project = FactoryGirl.build_stubbed(:project)
    expect{ project.quotes }.not_to raise_error
  end

  describe Project, "#update_status" do
    it "it updates the status of the project" do
      project = FactoryGirl.create(:project)

      project.update_status("completed")

      expect(project.project_status).to eq("completed")
    end
  end

end
