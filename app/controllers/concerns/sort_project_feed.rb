module SortProjectFeed
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "Invitedonly"
      @projects = Project.where(id: @current_business.quote_requests.pluck(:project_id))
    when "Dateadded"
      @projects = projects.order(created_at: :desc)
    when "Distance"
      locs = Location.near([21.4858, 39.1925], 8_000_000 , order: 'distance')
      @projects = projects.select('projects.*, projects.id as project_id').includes(:sub_categories).joins(:location).merge(locs)
      @projects = Project.where(id: @projects.collect(&:project_id))
    else
      @projects
    end

  end

  def handle_sorting_with_category_city(projects, category_ids, city_ids, timeline_types)
    projects = projects.where( timeline_type: timeline_types) unless timeline_types.size.zero?
    projects = projects.where( category_id: category_ids) unless category_ids.size.zero?
    projects = projects.by_city(city_ids) if city_ids
    @projects = projects
  end

end

