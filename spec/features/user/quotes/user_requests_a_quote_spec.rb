require "rails_helper"

RSpec.feature "User requests a quote" do

  scenario "They are presented with a list of their project and choose the first one. The business is notified of the quote request" do
    user = user_logs_in(:has_projects)
    user.projects.first.update(approved: true)

    business = FactoryGirl.create(:business)

    visit business_path(business, city: City.first.name)

    find_by_id(user.projects.first.title).click

    expect(business.incoming_notifications.count).to equal(1)
  end

end
