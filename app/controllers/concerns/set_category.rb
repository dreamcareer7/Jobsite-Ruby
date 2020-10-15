module SetCategory
  extend ActiveSupport::Concern

  def set_category
    @project = Project.find_by_id(params[:project_id])
    @category = Category.find_by_slug(params[:category_slug])

    @project.update(category_id: @category.id)
    
    respond_to do |format|
      format.js {}
    end
  end

end
