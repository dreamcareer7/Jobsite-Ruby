30.times do
  user = User.offset(rand(User.count)).first

  user.user_callbacks.create(
    user_number: 1234567,
    business_id: Business.offset(rand(Business.count)).first.id
  )
end

