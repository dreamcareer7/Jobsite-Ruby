FactoryGirl.define do
  factory :sponsor do
    association :location_owner, factory: :country
    association :listing_owner, factory: :sub_category
  end
end
