#require "rails_helper"
#
#RSpec.feature "Business chooses or creates a services" do
#
#  scenario "They update their business by choosing a service" do
#    user = user_logs_in(:has_standard_business)
#    business = user.businesses.first
#
#    find(:xpath, "//a[@href='/user/businesses']", match: :first).click
#    find(:xpath, "//a[@href='/business/profile?business=#{business.id}']", match: :first).click
#    find(:xpath, "//a[@href='/business/businesses/#{business.id}/edit']", match: :first).click
#
#    fill_in "business_name", with: "Something cool"
#
#    select business.services.first.name, from: 'business_service_ids'
#
#    submit_form
#
#    expect(business.services.first.name).to eq(business.services.first.name)
#
#  end
#
#end
