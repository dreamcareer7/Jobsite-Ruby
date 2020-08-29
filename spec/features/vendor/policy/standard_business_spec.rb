#require "rails_helper"
#
#RSpec.feature "A standard business unlocks more functionality" do
#
#  scenario "It allows the business to fill in more details"
#
#  scenario "It allows the business to view the project feed but is delayed by 10 hours" do
#    project = FactoryGirl.create(:project)
#    project2 = FactoryGirl.create(:project)
#    user = user_logs_in(:has_standard_business)
#    business = user.businesses.first
#    project2.location.update_attributes(city_id: 1)
#    business.locations.first.update_attributes(city_id: 1)
#
#    project.update_attributes(title: "Brand new project", created_at: 2.hours.ago)
#    project.location.update_attributes(city_id: 1)
#    business.locations.first.update_attributes(city_id: 1)
#
#    visit(business_profile_index_path(id: business))
#    find(:xpath, "//a[@href='/business/project_feed']", match: :first).click
#
#    expect(page).to have_content(project2.title)
#    expect(page).not_to have_content(project.title)
#
#  end
#
#  scenario "It allows the business to send quotes" do
#    quote = FactoryGirl.build_stubbed(:quote)
#    project = FactoryGirl.create(:project)
#    user = user_logs_in(:has_standard_business)
#    business = user.businesses.first
#    project.location.update_attributes(city_id: 1)
#    business.locations.first.update_attributes(city_id: 1)
#    project.shortlists.create(business_id: business.id)
#
#    visit(business_profile_index_path(id: business))
#    find(:xpath, "//a[@href='/business/project_feed']", match: :first).click
#    find(:xpath, "//a[@href='/business/project_feed/#{Project.first.id}']", match: :first).click
#    find(:xpath, "//a[@href='/business/quotes/new?project_id=#{project.id}']").click
#
#    fill_in "quote_proposal", with: quote.proposal
#    select quote.approximate_duration, from: "quote_approximate_duration"
#    select quote.approximate_budget, from: "quote_approximate_budget"
#    submit_form
#
#    expect(business.quotes.count).to eq(1)
#
#  end
#
#  scenario "It allows the business to view reports"
#
#  scenario "It allows the business to view reviews and respond to them"
#end
