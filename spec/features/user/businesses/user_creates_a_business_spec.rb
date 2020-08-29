require "rails_helper"

RSpec.feature "User creates a business" do

  scenario "They click button to add a new business and are presented with new business form" do
    user_logs_in

    find(:xpath, "//a[@href='/user/businesses/new']", match: :first).click

    expect(page).to have_selector("#new_business")
  end

  scenario "They fill in and submit new business form. They are brought to the business dashboard for that business" do
    business = FactoryGirl.build_stubbed(:business)

    user_logs_in

    find(:xpath, "//a[@href='/user/businesses/new']", match: :first).click

    fill_in "business_name", with: business.name

    find("#new-business").click

    expect(current_path).to eq(business_profile_index_path)
  end


end

