FactoryGirl.define do
  factory :review do
    reliability 2
    tidiness 4
    courtesy 3
    workmanship 4
    value_for_money 3
    recommended true
    user
    business
    project

    trait :positive do
      reliability 4
      tidiness 4
      courtesy 4
      workmanship 4
      value_for_money 5
      recommended true
      user
      business
      project
    end

    trait :negative do
      reliability 2
      tidiness 2
      courtesy 2
      workmanship 2
      value_for_money 1
      recommended false
      user
      business
      project
    end

  end
end
