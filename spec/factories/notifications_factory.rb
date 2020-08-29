FactoryGirl.define do
  factory :notification do
    before :create do |notification|
      user = create(:user)
      business = create(:business)
      notification.sending_user_id = user.id
      notification.receiving_user_id = business.id
    end
    before :build do |notification|
      user = create(:user)
      business = create(:business)
      notification.sending_user_id = user.id
      notification.receiving_user_id = business.id
    end
    title 'Hi there'
    body 'Just thinking about you!'
    notification_type 'personal'
    sending_user_type "User"
    receiving_user_type "Business"

    trait :quote do
      body "Your project has a new quote"
      notification_type "quote"
    end
  end
end
