#require "rails_helper"
#
#RSpec.feature "A free user is limited to two quote requests a month" do
#
#  scenario "They try to request a third quote and are blocked with a message explaining why" do
#    user = user_logs_in(:has_pending_quote_requests)
#    project = FactoryGirl.create(:project)
#    project.user = user
#    project.save
#    business = FactoryGirl.create(:business)
#
#    visit(businesses_path(city: City.first.name))
#
#    find(:xpath, "//a[@href='/#{City.first.name}/businesses/#{business.slug}']").click
#    find_by_id("quote-request").click
#    find_by_id(project.title).click
#
#    expect(page).to have_content("Sorry, you must be a pro user to request more than two quotes a month.")
#  end
#
#  scenario "Their quote request is refunded if their is no response in 48 hours" do
#    user = user_logs_in(:has_quote_request_available_for_refund)
#    project = FactoryGirl.create(:project)
#    project.user = user
#    project.save
#
#    business = FactoryGirl.create(:business)
#
#    visit(businesses_path(city: City.first.name))
#
#    find(:xpath, "//a[@href='/#{City.first.name}/businesses/#{business.slug}']").click
#    find_by_id("quote-request").click
#    find_by_id(project.title).click
#    expect(page).not_to have_content("Sorry, you must be a pro user to request more than two quotes a month.")
#  end
#
#end
