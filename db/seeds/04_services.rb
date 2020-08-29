27.times do
  Service.create(
    name: Faker::Company.profession,
    sub_category_id: SubCategory.offset(rand(SubCategory.count)).first.id
  )
end
27.times do
  Service.create(
    name: Faker::Commerce.department(2, true),
    sub_category_id: SubCategory.offset(rand(SubCategory.count)).first.id
  )
end
27.times do
  Service.create(
    name: Faker::Commerce.department(3, true),
    sub_category_id: SubCategory.offset(rand(SubCategory.count)).first.id
  )
end
200.times do
  Service.create(
    name: Faker::Hacker.noun,
    sub_category_id: SubCategory.offset(rand(SubCategory.count)).first.id
  )
end
200.times do
  Service.create(
    name: Faker::Name.title,
    sub_category_id: SubCategory.offset(rand(SubCategory.count)).first.id
  )
end
