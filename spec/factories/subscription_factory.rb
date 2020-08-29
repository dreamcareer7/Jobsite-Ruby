FactoryGirl.define do
  factory :subscription do
    subscription_type "free"
    expiry_date 1.week.from_now
  end
end
