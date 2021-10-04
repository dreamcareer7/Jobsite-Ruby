namespace :cleanup do
  #https://github.com/schneems/wicked/wiki/Building-Partial-Objects-Step-by-Step
  
  desc "cleanup projects that have not been fully created"
  task :projects => :environment do
    # Find all the products older than yesterday, that are not active yet
    incomplete_projects = Project.where("DATE(created_at) < DATE(?)", Date.yesterday).where.not(status: active)

    # delete them
    incomplete_projects.map(&:destroy)
  end
end
