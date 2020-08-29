module SortAppliedAndShortlisted
  extend ActiveSupport::Concern

  def sort_businesses(projects, filter_term)

    case filter_term

    when "Interested"
      @businesses = Business.where(id: @project.applied_to_projects.pluck(:business_id)).where.not(id: @project.shortlists.pluck(:business_id))
    when "Shortlisted"
      @businesses = Business.where(id: @project.shortlists.pluck(:business_id))
    else
      @businesses
    end

  end

end
