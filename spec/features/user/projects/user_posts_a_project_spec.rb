#require "rails_helper"
#
#RSpec.feature "User posts a project" do
#
#  scenario "They click button to add a new project and are presented with new project form" do
#
#    user_logs_in
#
#    find(:xpath, "//a[@href='/user/projects/new']", match: :first).click
#
#    expect(page).to have_content("Post a project")
#
#  end
#
#  scenario "They fill in and submit new project form"
#    #project = FactoryGirl.build(:project)
#    #service = project.services.first
#
#    #user = user_logs_in
#
#    #find(:xpath, "//a[@href='/user/projects/new']").click
#
#    #fill_in "project_title", with: project.title
#
#    #submit_form
#
#    #expect(current_path).to eq(user_project_path(user.projects.last.id))
#    #expect(page).to have_content(project.description)
#
#  scenario "They are presented with a list of recommended businesses"
#
#end
