# Create regular users

300.times do

  city = City.offset(rand(City.count)).first

  user = User.new(
    name: Faker::Name.name,
    gender: ["male", "female"].sample,
    age: Faker::Number.between(18, 90),
    birthday: Faker::Date.between(90.years.ago, 18.years.ago),
    nationality: Faker::Address.country,
    industry: User.industries.keys.sample,
    mobile_number: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email,
    password: "testingtest",
  )

  user.build_location(city_id: city.id, zip: 23412, street_address: "404 Nowhere, Rd", latitude: city.latitude, longitude: city.longitude)

  user.save

end

# Create an admin

Admin.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
