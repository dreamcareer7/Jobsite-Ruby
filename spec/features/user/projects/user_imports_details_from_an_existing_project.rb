require "rails_helper"

RSpec.feature "User imports details from an existing project" do

  scenario "They click a button to import details from another project and are presented with a list of existing projects" do

    user = user_logs_in(:has_projects)
    user.subscriptions.first.update_columns(subscription_type: "pro")

    find(:xpath, "//a[@href='/user/projects/new']", match: :first).click

    find_by_id("import-details").click

    find(user.projects.first.title).click

    expect(page).to have_content(user.projects.first.description)

  end

end

