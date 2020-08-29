FactoryGirl.define do
  factory :banner_target do
    banner
    target_listing factory: :sub_category
    target_location factory: :country
  end
end
