#require "rails_helper"
#
#RSpec.feature "User views their projects" do
#
#  scenario "They view project index in profile and are presented with a list of their projects" do
#    project = FactoryGirl.build_stubbed(:project)
#
#    user_logs_in(:has_projects)
#
#    find(:xpath, "//a[@href='/user/projects']", match: :first).click
#
#    expect(page).to have_content(project.title)
#  end
#
#  #scenario "They click on a project in the index and are shown project details" do
#  #  project = FactoryGirl.build_stubbed(:project)
#
#  #  user = user_logs_in(:has_projects)
#
#  #  find(:xpath, "//a[@href='/user/projects']", match: :first).click
#  #  find(:xpath, "//a[@href='/user/projects/#{user.projects.first.id}']").click
#
#  #  expect(page).to have_content(project.description)
#  #end
#end
