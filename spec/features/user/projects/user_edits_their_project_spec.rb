require "rails_helper"

RSpec.feature "User edits their project" do

  #scenario "They fill out and submit edit form" do

  #  user = user_logs_in(:has_projects)

  #  find(:xpath, "//a[@href='/user/projects']", match: :first).click
  #  find(:xpath, "//a[@href='/user/projects/#{user.projects.first.id}']").click
  #  find(:xpath, "//a[@href='/user/projects/#{user.projects.first.id}/edit']").click

  #  fill_in "project_title", with: "New project title"

  #  find("#submit-project").click

  #  expect(page).to have_content("New project title")

  #end

  #scenario "They delete their project" do
  #  user = user_logs_in(:has_projects)
  #  project = user.projects.first

  #  find(:xpath, "//a[@href='/user/projects']", match: :first).click
  #  find(:xpath, "//a[@href='/user/projects/#{project.id}']").click
  #  find(:xpath, "//a[@href='/user/projects/#{project.id}' and @data-method='delete']").click

  #  expect(user.projects.count).to eq(0)
  #end

end
