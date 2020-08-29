FactoryGirl.define do
  factory :sub_category do
    name "Carpet cleaing"
    category

    trait :has_service do
      after :create do |sub_category|
        create(:service, sub_category: sub_category)
      end
    end

  end
end
