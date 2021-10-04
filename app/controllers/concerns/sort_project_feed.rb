module SortProjectFeed
  extend ActiveSupport::Concern

  def handle_sorting(projects, filter_term)

    case filter_term

    when "Invitedonly"
      @projects = Project.where(id: @current_business.quote_requests.pluck(:project_id))
    else
      @projects
    end

  end

end

