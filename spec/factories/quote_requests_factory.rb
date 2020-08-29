FactoryGirl.define do
  factory :quote_request do
    project
    user
    business

    trait :pending do
      status "pending"
      created_at 1.days.ago
    end

    trait :pending_three_days do
      status "pending"
      created_at 3.days.ago
    end

    trait :accepted do
      status "accepted"
    end
  end
end
