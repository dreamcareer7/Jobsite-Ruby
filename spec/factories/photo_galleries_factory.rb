FactoryGirl.define do
  factory :photo_gallery do
    owner factory: :user
  end
end
