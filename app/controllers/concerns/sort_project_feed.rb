module SortProjectFeed
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "Invitedonly"
      @projects = Project.where(id: @current_business.quote_requests.pluck(:project_id))
    when "Dateadded"
      @projects = projects.order(created_at: :desc)
    when "Distance"
      locs = Location.where(owner_type: 'Project').near([request.location.latitude, request.location.longitude], 8_000_000)
      locs = locs.sort_by {|loc| loc.distance}
      project_ids = locs.collect(&:owner_id).uniq.compact
      order_clause = "CASE id "
      project_ids.each_with_index do |id, index|
        order_clause = order_clause + "WHEN #{id} THEN #{index} "
      end
      order_clause = order_clause + "ELSE #{project_ids.length} END"
      @projects = @projects.where(id: project_ids).order(order_clause)
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

