200.times do
  start_date = Faker::Date.between(3.days.from_now, 6.months.from_now)
  end_date = start_date + 14

  project = User.without_businesses.sample.projects.new(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.sentence(4),
    start_date: start_date,
    end_date: end_date,
    status: ["not started", "pending", "completed"].sample,
    creation_status: "active",
    project_budget: Faker::Number.between(0, 6),
    historical_structure: [true, false].sample,
    location_type: ["commercial", "residential"].sample,
    category: Category.all.sample
  )

  project.save!

  project.create_location(
    city: City.all.sample,
    zip: 1234,
    street_address: Faker::Address.street_address
  )

  @category = Category.find(project.category_id)

  3.times do
    project.project_services.create(service: @category.services.sample)
  end

end
