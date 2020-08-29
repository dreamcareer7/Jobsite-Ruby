require "rails_helper"

RSpec.describe "User receives a quote" do

  #scenario "They shortlist the quote and the quote is updated with a status" do
  #  user = user_logs_in(:has_project_with_quote)
  #  notification = user.incoming_notifications.first

  #  visit(user_notification_path(notification))

  #  find("#shortlist-quote").click

  #  expect(Quote.find(notification.quote_id).status).to eq("shortlist")
  #end

  #scenario "They deny the quote" do
  #  user = user_logs_in(:has_project_with_quote)
  #  notification = user.incoming_notifications.first

  #  visit(user_notification_path(notification))

  #  find("#deny-quote").click

  #  expect(Quote.find(notification.quote_id).status).to eq("denied")
  #end

end
