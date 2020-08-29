#require "rails_helper"
#
#RSpec.feature "A premium business unlocks all functionality" do
#
#  scenario "It allows the business to view recently created_projects" do
#    project = FactoryGirl.create(:project)
#    user = user_logs_in(:has_premium_business)
#    business = user.businesses.first
#
#    project.update_columns(title: "Brand new project", created_at: 2.hours.ago)
#    project.location.update_columns(city_id: 1)
#    business.locations.first.update_columns(city_id: 1)
#
#    visit(business_profile_index_path(id: business))
#    find(:xpath, "//a[@href='/business/project_feed']", match: :first).click
#
#    expect(page).to have_content(project.title)
#  end
#
#  scenario "It prevents competitor adds from being placed on their page" do
#    premium_business = FactoryGirl.create(:business, :premium)
#    standard_business = FactoryGirl.create(:business, :standard)
#
#    visit(business_path(city: City.first.name, id: premium_business))
#
#    expect(page).not_to have_content(standard_business.name)
#
#  end
#
#  scenario "It allows the business to broadcast messages"
#  scenario "It allows the business to receive industry analysis reports"
#end
