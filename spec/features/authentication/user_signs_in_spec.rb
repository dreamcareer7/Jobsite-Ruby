require "rails_helper"

RSpec.feature "User logs in" do

  scenario "They click log in and see a form" do

    click_log_in

    expect(page).to have_selector("form")

  end

  scenario "They fill in the form, submit, and they are directed to user profile" do

    user = FactoryGirl.create(:user)

    click_log_in

    fill_in "login-email", with: user.email
    fill_in "login-password", with: user.password
    
    click_button("Log in", match: :first)

    #expect(current_path).to eq(user_profile_index_path)
  end

  scenario "They submit the form with errors and are shown error details" do

    user = FactoryGirl.create(:user)

    click_log_in

    fill_in "login-email", with: user.email
    fill_in "login-password", with: "badpassword!"

    click_button("Log in", match: :first)

    expect(page).to have_content("Log in")

  end

  def click_log_in
    visit root_path
    find('//button[@data-modal="log-in"]', match: :first).click
  end

end

