#require "rails_helper"
#
#RSpec.feature "Business submits a quote for a project" do
#
#  scenario "It submits a quote" do
#
#    user = user_logs_in(:has_premium_business)
#    business = user.businesses.first
#    project = FactoryGirl.create(:project)
#    quote = FactoryGirl.build_stubbed(:quote)
#    project.shortlists.create(business_id: business.id)
#
#    project.location.update_columns(city_id: 1)
#    business.locations.first.update_columns(city_id: 1)
#
#    visit(business_profile_index_path(id: business))
#    find(:xpath, "//a[@href='/business/project_feed']", match: :first).click
#    find(:xpath, "//a[@href='/business/project_feed/#{project.id}']", match: :first).click
#    find(:xpath, "//a[@href='/business/quotes/new?project_id=#{project.id}']").click
#
#    fill_in "quote_proposal", with: quote.proposal
#    select quote.approximate_duration, from: "quote_approximate_duration"
#    select quote.approximate_budget, from: "quote_approximate_budget"
#    submit_form
#
#    expect(business.quotes.count).to eq(1)
#  end
#
#end
