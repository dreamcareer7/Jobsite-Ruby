FactoryGirl.define do
  factory :project do
    title "I need this done"
    description "This is a description of what I need done"
    start_date 1.day.from_now
    end_date 9.day.from_now
    historical_structure false
    location_type "private"
    user

    after :create do |project|
      project.update_attributes(created_at: 11.hours.ago)
      project.services << create(:service)
      create(:location, owner: project)
    end

    trait :has_quote do
      after :create do |project|
       quote = create(:quote, project: project)
       create(:notification, :quote, quote_id: quote.id, project_id: project.id, receiving_user_id: project.user.id )
      end
    end

    trait :has_accepted_quote do
      after :create do |project|
       create(:quote, :accepted, project: project)
      end
    end

    trait :completion_pending do
      after :create do |project|
       create(:quote, :accepted, project: project)
      end
      project_status :completion_pending
    end

    trait :is_completed do
      project_status :completed
    end

    trait :is_ongoing do
      project_status :in_process
    end

  end
end
