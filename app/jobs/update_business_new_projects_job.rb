class UpdateBusinessNewProjectsJob < ApplicationJob
  queue_as :default

  def perform
    @new_projects = Project.new_since(1).includes(:services, :city)
    return unless @new_projects.present?

    @target_businesses = Business.includes(:cities, :services)
      .by_city(@new_projects.map{ |project| project.city}.uniq.flatten)
      .by_service(@new_projects.map{ |project| project.services }.uniq.flatten).distinct
    return unless @target_businesses.present?

    @target_businesses.map do |business|
      target_projects = @new_projects.by_city(business.cities).by_services(business.services).distinct
      next unless target_projects.present?

      business.send_new_projects_email(business, target_projects.limit(3))
    end
  end

end
