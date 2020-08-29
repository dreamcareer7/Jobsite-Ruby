#require "rails_helper"
#
#RSpec.feature "User views their favourite businesses" do
#  scenario "They are shown a list of businesses they have favourited" do
#    user = user_logs_in(:has_favourites)
#
#    visit(user_follows_path)
#
#    expect(page).to have_content(user.vourites.first.business.name)
#  end
#end
