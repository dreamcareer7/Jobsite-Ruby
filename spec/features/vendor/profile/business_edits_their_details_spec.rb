require "rails_helper"

RSpec.feature "Business edits their details" do

  scenario "They fill out and submit edit form" do

    user = user_logs_in(:has_standard_business)
    business = user.businesses.first
    @current_business = business
    business_id = business.id

    visit(business_profile_index_path)
    find(:xpath, "//a[@href='/business/businesses/#{business.slug}/edit']", match: :first).click

    fill_in "business_email", with: "standardbusiness@test.com"

    submit_form

    expect(Business.find(business_id).email).to eq("standardbusiness@test.com")

  end

end
