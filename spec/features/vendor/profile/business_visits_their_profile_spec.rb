require "rails_helper"

RSpec.describe "Business visits their profile" do

  scenario "They see the details for their business" do
    user = user_logs_in(:has_standard_business)
    business = user.businesses.first
    @current_business = business

    visit(business_profile_index_path)

    expect(page).to have_content("Dashboard")

  end
end
