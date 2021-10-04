module ApplicationHelper

  # Returns wether the passed service is currently being displayed
  def current_service?(service)
    current_page?(controller: "/services", action: "show", id: service.friendly_id)
  end

  #devise helpers for ajax actions
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def set_filter(filter)
    filters = (params[:filters] || []).map(&:to_sym)
    filters.include?(filter) ? filters -= [filter] : filters += [filter]
    {filters: filters}
  end

  def filter_time_ranges
    [{
      title: t("stats.today"),
      from: Time.current.beginning_of_day,
      to: Time.current
    }, {
      title: t("stats.yesterday"),
      from: 1.day.ago.beginning_of_day,
      to: 1.day.ago.end_of_day
    }, {
      title: t("stats.this_week"),
      from: Time.current.beginning_of_week,
      to: Time.current
    }, {
      title: t("stats.last_week"),
      from: 1.week.ago.beginning_of_week,
      to: 1.week.ago.end_of_week
    }, {
      title: t("stats.this_month"),
      from: Time.current.beginning_of_month,
      to: Time.current
    }, {
      title: t("stats.last_month"),
      from: 1.month.ago.beginning_of_month,
      to: 1.month.ago.end_of_month
    }, {
      title: t("stats.last_year"),
      from: 1.year.ago.beginning_of_year,
      to: 1.year.ago.end_of_year
    }, {
      title: t("stats.this_year"),
      from: Time.current.beginning_of_year,
      to: Time.current,
      default: true
    }]
  end

end
