require "rails_helper"

RSpec.feature "User sends a message" do
  #scenario "They view the list of messages" do
  #  message = FactoryGirl.build_stubbed(:notification)

  #  user_logs_in(:received_a_message)

  #  find(:xpath, "//a[@href='/user/notifications']", match: :first).click

  #  expect(page).to have_content(message.sender.name)
  #end

  #scenario "They view an outgoing message" do
  #  #message = FactoryGirl.build_stubbed(:notification)

  #  #user = user_logs_in(:sent_a_message)

  #  #find(:xpath, "//a[@href='/user/notifications']").click
  #  #find(:xpath, "//a[@href='/user/notifications/#{user.outgoing_notifications.first.id}']").click

  #  #expect(page).to have_content(message.body)
  #end

  #scenario "They view an incoming message" do
  #  #message = FactoryGirl.build_stubbed(:notification)

  #  #user = user_logs_in(:received_a_message)

  #  #find(:xpath, "//a[@href='/user/notifications']").click
  #  #find(:xpath, "//a[@href='/user/notifications/#{user.incoming_notifications.first.id}']").click

  #  #expect(page).to have_content(message.body)
  #end

end
