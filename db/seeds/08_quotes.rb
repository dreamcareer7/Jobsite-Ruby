50.times do 
  Business.offset(rand(Business.count)).first.quotes.create(
    introduction: Faker::Lorem.sentence(3),
    proposal: Faker::Lorem.sentence(3),
    reference_number: Faker::Number.number(9),
    valid_until: Faker::Date.between(Date.today, 1.month.from_now),
    approximate_duration: Faker::Number.between(1, 90),
    approximate_budget: Faker::Number.between(1, 1000),
    project_id: Project.offset(rand(Project.count)).first.id,
  )
end
