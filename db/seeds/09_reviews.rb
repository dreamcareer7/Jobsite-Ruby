200.times do
  Project.offset(rand(Project.count)).first.create_review(
    reliability: Faker::Number.between(1, 5),
    tidiness: Faker::Number.between(1, 5),
    courtesy: Faker::Number.between(1, 5),
    workmanship: Faker::Number.between(1, 5),
    value_for_money: Faker::Number.between(1, 5),
    comment: Faker::Lorem.sentence(5),
    recommended: [true, false].sample,
    user_id: User.offset(rand(User.count)).first.id,
    business_id: Business.offset(rand(Business.count)).first.id,
  )
end
