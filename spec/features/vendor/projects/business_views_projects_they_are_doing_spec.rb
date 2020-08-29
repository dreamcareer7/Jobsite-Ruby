#require "rails_helper"
#
#RSpec.feature "Business views projects they are doing" do
#
#  scenario "It views projects in their list of projects" do
#    user = user_logs_in(:has_businesses_with_ongoing_projects)
#    business = user.businesses.first
#
#    visit(business_profile_index_path(id: business))
#    find(:xpath, "//a[@href='/business/projects']", match: :first).click
#
#    expect(page).to have_content(business.projects.first.title)
#
#  end
#
#end
