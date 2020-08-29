class Admin::StatisticsController < Admin::BaseController
  include GSA

  after_action :verify_authorized
  before_action :set_time_bounds
  before_action :perform_authorization

  def engagement
    respond_to do |format|
      format.html
      format.json {
        render json: {
          phone_calls: Impression.where(impressionable_type: 'Business', message: 'number_view', created_at: [@from..@to]).count,
          callback_requests: UserCallback.where(created_at: [@from..@to]).count,
          messages_by_users: Message.where(sending_user_type: 'User', created_at: [@from..@to]).count,
          responses_by_businesses: Message.where(sending_user_type: 'Business', created_at: [@from..@to]).count,
          website_visits: Impression.where(impressionable_type: 'Business', message: 'website_view', created_at: [@from..@to]).count,
          social_media_visits: Impression.where(impressionable_type: 'Business', message: 'social_view', created_at: [@from..@to]).count,
          interest_series: [{
            name: 'Phone calls',
            color: '#BE3E26',
            data: Impression.where(impressionable_type: 'Business', message: 'number_view').group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }, {
            name: 'Website visits',
            color: '#F5A623',
            data: Impression.where(impressionable_type: 'Business', message: 'website_view').group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }, {
            name: 'Social media visits',
            color: '#73b50a',
            data: Impression.where(impressionable_type: 'Business', message: 'social_view').group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }],
          outreach_series: [{
            name: 'Callback requests',
            color: '#BE3E26',
            data: UserCallback.group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }, {
            name: 'User messages',
            color: '#F5A623',
            data: Message.group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }, {
            name: 'Business responses',
            color: '#73b50a',
            data: Message.where(sending_user_type: 'Business').group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }]
        }
      }
    end
  end

  def businesses
    respond_to do |format|
      format.html
      format.json {
        render json: {
          total: Business.count,
          total_paid: Business.paid.count,
          new: Business.where(created_at: [@from..@to]).count,
          new_paid: Business.paid.where(created_at: [@from..@to]).count,
          most_viewed: Business.most_viewed(10).map{ |business_id, views| [Business.find(business_id).name, views] },
          most_followed: Business.most_favourites(10).map{ |business_id, views| [Business.find(business_id).name, views] },
          businesses_series: [{
            name: 'New businesses',
            color: '#BE3E26',
            data: Business.group_by_period(period, :created_at, range: @from..@to, format: '%s').count,
          }]
        }
      }
    end
  end

  def users
    respond_to do |format|
      format.html
      format.json {
        render json: {
          new: User.where(created_at: [@from..@to]).count,
          new_paid: User.paid.where(created_at: [@from..@to]).count,
          total: User.count,
          total_paid: User.paid.count,
          users_series: [{
            name: 'New users',
            color: '#BE3E26',
            data: User.group_by_period(period, :created_at, range: @from..@to, format: '%s').count
          }]
        }
      }
    end
  end

  def categories
    respond_to do |format|
      format.html
      format.json {
        render json: Category.all.map{ |category|
          {
            name: category.name,
            businesses: category.businesses.where(created_at: [@from..@to]).count,
            visits: Impression.where(created_at: [@from..@to], impressionable_type: 'SubCategory', action_name: 'show', impressionable_id: category.sub_categories.ids).count,
            projects: category.projects.count,
            sub_categories: category.sub_categories.map{ |sub_category|
              {
                name: sub_category.name,
                businesses: sub_category.businesses.where(created_at: [@from..@to]).count,
                visits: Impression.where(created_at: [@from..@to], impressionable_type: 'SubCategory', action_name: 'show', impressionable_id: sub_category.id).count,
                projects: category.projects.count
              }
            }
          }
        }
      }
    end
  end

  def analytics
    @access_token = return_access_token
  end

  protected

  def set_time_bounds
    @from = params['from'] ? Time.zone.at(params['from'].to_i) : 0
    @to = params['to'] ? Time.zone.at(params['to'].to_i) : 0
  end

  def period
    return @period if @period
    duration = @to - @from
    return @period = :week if duration > 2.months
    return @period = :day if duration > 2.days
    @period = :hour
  end

  def perform_authorization
    authorize :statistics
  end

  def policy(record)
    Admin::StatisticsPolicy.new(current_admin, record)
  end
end
