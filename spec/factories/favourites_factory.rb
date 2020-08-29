FactoryGirl.define do
  factory :favourite do
    association :user, factory: [:user]
    association :business, factory: [:business]
  end
end
