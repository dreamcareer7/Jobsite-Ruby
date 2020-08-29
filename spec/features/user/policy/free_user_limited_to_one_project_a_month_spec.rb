require "rails_helper"

RSpec.feature "A free user is limited to one project a month" do

  scenario "They try to add a second project and are blocked with a message explaining why" do
    #user_logs_in(:has_projects)

    #visit(new_user_project_path)

    #expect(page).to have_content("Sorry, you must be a pro user to post more than 1 project a month.")

  end

  scenario "They try to add a second project one month later and are successful"
   # project = FactoryGirl.build_stubbed(:project)
   # user = user_logs_in(:has_projects)
   # project = user.projects.first
   # user.projects.first.update_columns(created_at: 2.months.ago)

   # visit(new_user_project_path)

   # fill_in "project_title", with: project.title

   # find_button("Continue", match: :first).click
   # find_button("Continue", match: :first).click
   # fill_in "project_description", with: project.description
   # find_button("Post a project", match: :first).click
   # 
   # expect(user.projects.count).to eq(2)


end
