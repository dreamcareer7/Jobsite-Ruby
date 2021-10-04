class Business::StatsController < Business::BaseController

  def index
    respond_to do |format|
      format.html

      format.json {
        @from = Time.zone.at(params['from'].to_i)
        @to = Time.zone.at(params['to'].to_i)

        render json: {
          impressions: current_business.impressions.where(
            message: 'profile_view',
            created_at: @from..@to
          ).order("DATE_TRUNC('day', impressions.created_at)").group("DATE_TRUNC('day', impressions.created_at)").count,
          profile_views: current_business.impressionist_count(start_date: @from, end_date: @to, message: "profile_view", filter: :all),
          project_views: current_business.impressionist_count(start_date: @from, end_date: @to, message: "project_view", filter: :all),
          listing_views: current_business.impressionist_count(start_date: @from, end_date: @to, message: "listing_view", filter: :all),
          recommendations: 0,
          website_visits: current_business.impressionist_count(start_date: @from, end_date: @to, message: "website_view", filter: :all),
          social_media_visits: current_business.impressionist_count(start_date: @from, end_date: @to, message: "social_view", filter: :all),
          phone_number_reveals: current_business.impressionist_count(start_date: @from, end_date: @to, message: "number_view", filter: :all),
          new_messages: current_business.incoming_messages.where(created_at: @from..@to).count + current_business.incoming_notifications.where(created_at: @from..@to).count,
          callback_requests: current_business.user_callbacks.where(created_at: @from..@to).count,
          projects_applied: current_business.applied_to_projects.where(created_at: @from..@to).count,
          projects_shortlisted: current_business.shortlists.where(created_at: @from..@to).count,
          projects_completed: Project.where(business_id: current_business.id, project_status: :completed, created_at: @from..@to).count,
          projects_won: Project.where(business_id: current_business.id, created_at: @from..@to).count,
          customer_reviews: Project.where(id: current_business.projects.pluck(:id), created_at: @from..@to).count,
          favourites: Follow.where(follow_target_id: current_business.id, follow_target_type: "Business", created_at: @from..@to).count
        }
      }
    end

  end

end
