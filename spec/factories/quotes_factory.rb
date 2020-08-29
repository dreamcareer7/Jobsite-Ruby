FactoryGirl.define do
  factory :quote do
    proposal "Hi I can get that done"
    reference_number 14124
    valid_until 2.weeks.from_now
    approximate_duration "0 - 5 days"
    approximate_budget "$0 - $1000"
    business
    project
    status "pending"

    trait :accepted do
      status "accepted"
    end

    trait :ongoing_project do
      status "accepted"
      association :project, factory: [:project, :is_ongoing]
    end

    trait :completed_project do
      status "accepted"
      association :project, factory: [:project, :is_completed]
    end

  end
end
