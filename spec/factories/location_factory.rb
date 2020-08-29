FactoryGirl.define do
  factory :location do
    city
    zip "12345"
    street_address "404 Somewhere, Rd"
    association :owner, factory: :business

    trait :initial_owner_blank do
      association :owner
    end

  end
end
