class Business::SelfAddedProjectsController < Business::BaseController
  def update
    @self_added_project = SelfAddedProject.find(params[:id])

    if @self_added_project.update_attributes(self_added_project_params)
      redirect_back(fallback_location: business_profile_index_path) 
      flash[:notice] = "Business profile updated."
    else
      redirect_back(fallback_location: business_profile_index_path) 
      flash[:error] = "There was an error uploading your image."
    end
  end

  private

  def self_added_project_params
    params.require(:self_added_project).permit(:title, :video_link, :description, :image_one, :image_two, :image_three)
  end
end
