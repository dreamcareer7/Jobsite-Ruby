module SetCategory
  extend ActiveSupport::Concern

  def set_category
    #adapted from https://kernelgarden.wordpress.com/2014/02/26/dynamic-select-boxes-in-rails-4/

    @category = Category.find_by_slug(params[:category_slug])
    @project = Project.find_by_id(params[:project_id])
    @edit_path = "/user/projects/#{params[:project_id]}/project_steps/project_details"

    @project.update(category_id: @category.id)
    @f = params[:form_builder]
    
    # @project.project_services.build
    respond_to do |format|
      format.js {}
    end
  end

end
