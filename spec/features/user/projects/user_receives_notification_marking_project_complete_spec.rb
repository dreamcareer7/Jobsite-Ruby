require "rails_helper"

RSpec.describe "User receives notification marking project as complete" do

  #TODO need to refactor to take into account new flow
  
  #scenario "They confirm the completion and the project is updated with a status" do

  #  user = user_logs_in(:has_project_with_completion_pending)
  #  project = user.projects.first

  #  visit(user_project_path(project))

  #  expect(current_path).to eq("/user/projects/#{project.id}")

  #  click_button("accept completion #{project.id}")

  #  expect(user.projects.first.status).to eq("completed")

  #end

  #scenario "They confirm completion and the user is prompted to leave a review" do
  #  user = user_logs_in(:has_project_with_completion_pending)
  #  project = user.projects.first

  #  visit(user_project_path(project))

  #  expect(current_path).to eq("/user/projects/#{project.id}")

  #  click_button("accept completion #{project.id}")

  #  expect(current_path).to eq("/user/reviews/new")
  #  expect(page).to have_selector("form")

  #end

  #scenario "They do not accept completion and the project status is updated" do

  #  user = user_logs_in(:has_project_with_completion_pending)
  #  project = user.projects.first

  #  visit(user_project_path(project))

  #  click_button("deny completion #{project.id}")

  #  expect(user.projects.first.status).to eq("completion denied")

  #end

  #scenario "They deny completion and the user is prompted send a notification to business explaining why" do
  #  user = user_logs_in(:has_project_with_completion_pending)
  #  project = user.projects.first

  #  visit(user_project_path(project))

  #  click_button("deny completion #{project.id}")

  #  expect(page).to have_selector("form")
  #end

end

