module HandleProjectBatch
  extend ActiveSupport::Concern

  def check_required_categories(categories)
    @project.update_attributes(category_id: categories)
    #when array of categories
    #@project.update_attributes(category_id: categories.shift)

    #check if more than one category specified
    #create_additional_projects(categories) if categories.present?
  end

  def create_additional_projects(categories)

    if @project.project_batch.present?
      @project_batch = @project.project_batch
      #returns unless there is a nil value in project_batch
      return unless @project_batch.vacancy? 
    else
      @project_batch = ProjectBatch.create
      @project_batch.project1 = @project.id
      @project_batch.save!
    end

    categories.each do |category|
      #only create a new project if it does not already exist in project_batch
      next if @project_batch.category_present?(Category.find(category))

      project = current_user.projects.create(project_params)
      project.update_attributes(category_id: category, creation_status: "additional_information")
      @project_batch.project2.blank? ? @project_batch.project2 = project.id : @project_batch.project3 = project.id
      @project_batch.save!
    end

    add_location_to_additional_projects

  end

  def add_location_to_additional_projects

    @project_batch.projects.each do |project|
      next if project.location.present?

      project.create_location(
        city_id: @project.location.city_id,
        zip: @project.location.zip,
        po_box: @project.location.po_box,
        street_address: @project.location.street_address,
        latitude: @project.location.latitude,
        longitude: @project.location.longitude
      )

    end
  end

  def check_batched_project_status
    #TODO refactor
    #looks through project_batch projects for any projects that are not fully setup
    project_to_complete = @project.project_batch.projects.select{ |project| project.creation_status == "additional_information" }.first

    #rerenders additional_information step with appropriate project
    jump_to(:additional_information, project_id: project_to_complete.id)
  end

end
