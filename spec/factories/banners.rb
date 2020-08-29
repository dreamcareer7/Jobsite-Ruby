FactoryGirl.define do
  factory :banner do
    before :create do |banner|
      build(:banner_target, banner: banner)
    end
    title "Cool Banner"
    link_en "www.google.com"
    start_date 2.weeks.from_now
    end_date   6.weeks.from_now
  end
end
