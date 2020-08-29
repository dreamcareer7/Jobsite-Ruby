require "rails_helper"

RSpec.feature "User leaves a review" do

  #TODO refactor to take into account new flow

  #scenario "They mark a project as completed and submit a review. The business is notified." do
  #  review = FactoryGirl.build_stubbed(:review)
  #  user = user_logs_in(:has_project_with_completion_pending)
  #  project = user.projects.first

  #  visit(user_project_path(project))

  #  expect(current_path).to eq("/user/projects/#{project.id}")

  #  click_button("accept completion #{project.id}")

  #  expect(user.projects.first.status).to eq("completed")
  #  expect(current_path).to eq("/user/reviews/new")

  #  select review.reliability, from: "review_reliability"
  #  select review.tidiness, from: "review_tidiness"
  #  select review.courtesy, from: "review_courtesy"
  #  select review.workmanship, from: "review_workmanship"
  #  select review.value_for_money, from: "review_value_for_money"
  #  fill_in "review_comment", with: "Cool. Stuff's clean!"
  #  select review.recommended, from: "review_recommended"

  #  submit_form

  #  expect(current_path).to eq(user_reviews_path)
  #  expect(project.quotes.first.business.incoming_notifications.count).to eq(1)

  #end

  scenario "The business views its reviews and views a specific review" do
    user = user_logs_in(:has_a_business_with_a_review)
    @current_business = user.businesses.first

    visit(business_profile_index_path)

    find(:xpath, "//a[@href='/business/businesses/#{user.businesses.first.slug}/edit']", match: :first).click

    visit(business_reviews_path)

    #expect(page).to have_content(business.reviews.first.project.title)

    #find(:xpath, "//a[@href='/business/reviews/#{business.reviews.first.id}']").click

    #expect(page).to have_content(business.reviews.first.workmanship)

  end
end
