#require "rails_helper"
#
#RSpec.feature "Business views projects" do
#
#  before :each do
#    user = user_logs_in(:has_standard_business)
#    business = user.businesses.first
#    business.locations.first.update_columns(city_id: 1)
#
#    visit(business_profile_index_path(id: business))
#
#  end
#
#  scenario "It views project index and is presented with a list of available projects" do
#
#    find(:xpath, "//a[@href='/business/project_feed']", match: :first).click
#
#  end
#
#  scenario "It clicks on a business in the index and is shown the project details" do
#    project = FactoryGirl.create(:project)
#    project.update_columns(created_at: 11.hours.ago)
#    project.location.update_columns(city_id: 1)
#
#    find(:xpath, "//a[@href='/business/project_feed']", match: :first).click
#    find(:xpath, "//a[@href='/business/project_feed/#{project.id}']", match: :first).click
#
#    expect(page).to have_content(project.title)
#
#  end
#
#end
