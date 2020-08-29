require "rails_helper"

RSpec.feature "Visitor signs up" do

  scenario "They click sign up and see a form" do

    click_sign_up

    expect(page).to have_selector("form")

  end

  scenario "They fill in the form, submit, and they are told they will receive a confirmation email." do

    click_sign_up

    fill_in("user_name", with: "Steven", exact: true, match: :first)
    fill_in("user_mobile_number", with: "1234567", exact: true, match: :first)
    fill_in("user_email", with: "tes12@test.com", exact: true, match: :first)
    fill_in("user_password", with: "testingtest", exact: true, match: :first)

    find("#sign-up").click


    expect(current_path).to eq(registered_path)
  end

  scenario "They submit the form with errors and are shown error details" do

    click_sign_up

    fill_in("user_email", with: "tes12@test.com", exact: true, match: :first)
    fill_in("user_password", with: "testingtest", exact: true, match: :first)
    
    find("#sign-up").click
  end

  def click_sign_up
    visit root_path
    find('//button[@data-modal="sign-up"]', match: :first).click
  end

end

