module SortProjectFeed
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "Invitedonly"
      @projects = Project.where(id: @current_business.quote_requests.pluck(:project_id))
    when "Dateadded"
      @projects = projects.order(created_at: :desc)
    when "Distance"
      @projects = projects.includes(location: :city).order('cities.name ASC')
    else
      @projects
    end

  end

  def handle_sorting_with_category_city(projects, category_ids, city_ids)
    projects = projects.where( category_id: category_ids) unless category_ids.size.zero?
    projects = projects.by_city(city_ids) if city_ids
    @projects = projects
  end

end

