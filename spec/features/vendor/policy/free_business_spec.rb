require "rails_helper"

#RSpec.feature "A free business is limited to a basic profile" do
#  scenario "They cannot edit more than the basic profile attributes"
#
#  scenario "They try to view the project feed but are blocked by a message explaining why" do
#    project = FactoryGirl.create(:project)
#    user = user_logs_in(:has_free_business)
#    business = user.businesses.first
#
#    visit(business_profile_index_path(id: business))
#    visit(business_project_feed_path(project))
#
#    expect(page).to have_content("Sorry, you must be a standard or premium business to view projects from the project feed.")
#  end
#
#end
