require "rails_helper"

RSpec.feature "User favourites a business" do

  scenario "They view a business and click favourite." do

    business = FactoryGirl.create(:business)
    user = user_logs_in

    visit(business_path(id: business.id, city: City.first.name))

    click_link("favourite #{business.id}")

    expect(user.follows.count).to eq(1)

  end

end

