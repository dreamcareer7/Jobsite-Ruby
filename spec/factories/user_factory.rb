FactoryGirl.define do
  factory :user do
    before :create do |user|
      create(:location, :initial_owner_blank, owner: user)
      user.confirm!
    end

    name "Cool User"
    sequence(:email) { |n| "user#{n}@test.com" }
    password "testingtest"
    mobile_number "1234567"

    trait :has_free_business do
      after :create do |user|
        create(:business, user: user)
      end
    end

    trait :has_standard_business do
      after :create do |user|
        create(:business, :standard, user: user)
      end
    end

    trait :has_premium_business do
      after :create do |user|
        create(:business, :premium, user: user)
      end
    end

    trait :pro do
      after :create do |user|
        user.subscription.subscription_type == "pro"
      end
    end

    trait :has_businesses_with_ongoing_projects do
      after :create do |user|
        create(:business, :has_ongoing_projects, user: user)
      end
    end

    trait :has_a_business_with_a_review do
      after :create do |user|
        create(:business, :has_a_positive_review, user: user)
      end
    end

    trait :has_projects do
      after :create do |user|
        create(:project, user: user)
      end
    end

    trait :has_project_with_quote do
      after :create do |user|
        create(:project , :has_quote, user: user)
      end
    end

    trait :has_project_with_completion_pending do
      after :create do |user|
        create(:project , :completion_pending, user: user)
      end
    end

    trait :sent_a_message do
      after :create do |user|
        user2 = FactoryGirl.create(:user)
        create(:notification, sending_user_id: user.id, receiving_user_id: user2.id)
      end
    end

    trait :received_a_message do
      after :create do |user|
        user2 = FactoryGirl.create(:user)
        create(:notification, sending_user_id: user2.id, receiving_user_id: user.id)
      end
    end

    trait :has_pending_quote_requests do
      after :create do |user|
        2.times do
          create(:quote_request, :pending, user: user)
        end
      end
    end

    trait :has_quote_request_available_for_refund do
      after :create do |user|
        create(:quote_request, :pending, user: user)
        create(:quote_request, :pending_three_days, user: user)
      end
    end

    trait :has_favourites do
      after :create do |user|
        business = FactoryGirl.create(:business)
        create(:favourite, user: user, business: business)
      end
    end

  end
end
