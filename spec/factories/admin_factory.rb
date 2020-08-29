FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@test.com" }
    password "testingtest"
  end
end
