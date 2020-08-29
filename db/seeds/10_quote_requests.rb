30.times do
  project = Project.offset(rand(Project.count)).first
  project.quote_requests.create(
    user_id: project.user.id,
    business_id: Business.offset(rand(Business.count)).first.id,
  )
end
