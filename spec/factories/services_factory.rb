FactoryGirl.define do
  factory :service do
    initialize_with { Service.find_or_create_by(name: "Steam cleaning") }
    sub_category
  end
end

