FactoryGirl.define do
  factory :category do
    name "Cleaning"

    trait :has_sub_category do
      after :create do |category|
        create(:sub_category, :has_service, category: category)
      end
    end

  end
end 
