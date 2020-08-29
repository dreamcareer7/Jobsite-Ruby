FactoryGirl.define do
  factory :business do
    before :create do |business|
      business.services << FactoryGirl.create(:service)
      create(:location, :initial_owner_blank, owner: business)
    end

    name 'A Great Business'
    email 'agreatbusiness@test.com'
    telephone '123.456.7890'
    user
    approved true

    trait :standard do
      after :create do |business|
        business.update_attributes(name: "Standard business")
        business.user.subscriptions.first.update_attributes(subscription_type: "standard", expiry_date: 1.month.from_now)
      end
    end

    trait :premium do
      after :create do |business|
        business.update_attributes(name: "Premium business")
        business.user.subscriptions.first.update_attributes(subscription_type: "premium", expiry_date: 1.month.from_now)
      end
    end

    trait :has_accepted_quotes do
      after :create do |business|
        create(:quote, :accepted, business: business)
      end
    end

    trait :has_pending_quotes do
      after :create do |business|
        create(:quote, business: business)
      end
    end

    trait :has_ongoing_projects do
      after :create do |business|
        create(:quote, :ongoing_project, business: business, project_status: :accepted)
        create(:project, project_status: :in_process, business_id: business.id)
      end
    end

    trait :has_completed_projects do
      after :create do |business|
        create(:quote, :completed_project, business: business)
      end
    end

    trait :has_a_positive_review do
      after :create do |business|
        create(:review, :positive, business: business)
      end
    end

    trait :has_a_negative_review do
      after :create do |business|
        create(:review, :negative, business: business)
      end
    end

    trait :has_multiple_reviews do
      after :create do |business|
        create(:review, :positive, business: business)
        create(:review, :negative, business: business)
        create(:review, :positive, business: business)
      end
    end

    trait :no_user do
      user nil
    end

  end
end
