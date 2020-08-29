class Admin::GalleriesController < Admin::BaseController
  before_action :set_record, only: [:destroy_video_link, :destroy_business_image, :destroy_attachment, :destroy_banner]

  def business_banners
    respond_to do |format|
      format.html
      format.json { render json: BusinessBannerDatatable.new(view_context) }
    end
  end

  def user_projects
    respond_to do |format|
      format.html
      format.json { render json: UserProjectDatatable.new(view_context) }
    end
  end

  def business_projects
    respond_to do |format|
      format.html
      format.json { render json: BusinessProjectDatatable.new(view_context) }
    end
  end

  def business_logos
    respond_to do |format|
      format.html
      format.json { render json: BusinessLogoDatatable.new(view_context) }
    end
  end

  def destroy_video_link
    begin
      project = SelfAddedProject.find(@record_id)
      project.video_link = nil
      project.save

      if project.video_link == nil
        redirect_back(fallback_location: business_projects_admin_gallery_path)
        flash[:notice] = "Video was deleted."
      else
        redirect_back(fallback_location: business_projecs_admin_gallery_path)
        flash[:error] = "There was an error deleting the video."
      end

    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: business_projecs_admin_gallery_path)
      flash[:error] = "There was an error deleting the video."
    end
  end

  def destroy_business_image
    image = params[:image]

    if ["image_one", "image_two", "image_three"].include?(image)
      begin
        project = SelfAddedProject.find(@record_id)
        project.send(image).destroy

        if project.save
          redirect_back(fallback_location: business_projects_admin_gallery_path)
          flash[:notice] = "Image was deleted."
        else
          redirect_back(fallback_location: business_projecs_admin_gallery_path)
          flash[:error] = "There was an error deleting the image."
        end

      rescue ActiveRecord::RecordNotFound
        redirect_back(fallback_location: business_projects_admin_gallery_path)
        flash[:error] = "There was an error deleting the image."
      end
    end

  end

  def destroy_attachment
    begin
      attachment = Attachment.find(@record_id)

      if attachment.destroy
        redirect_back(fallback_location: business_projects_admin_gallery_path)
        flash[:notice] = "Image was deleted."
      else
        redirect_back(fallback_location: business_projecs_admin_gallery_path)
        flash[:error] = "There was an error deleting the image."
      end

    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: business_projects_admin_gallery_path)
      flash[:error] = "There was an error deleting the image."
    end
  end

  def destroy_banner
    begin
      business = Business.find(@record_id)

      business.banner.destroy

      if business.save
        redirect_back(fallback_location: business_banners_admin_gallery_path)
        flash[:notice] = "Image was deleted."
      else
        redirect_back(fallback_location: business_banners_admin_gallery_path)
        flash[:error] = "There was an error deleting the image."
      end

    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: business_banners_admin_gallery_path)
      flash[:error] = "There was an error deleting the image."
    end
  end

  def destroy_logo
    begin
      business = Business.find(@record_id)

      business.logo.destroy

      if business.save
        redirect_back(fallback_location: business_logos_admin_gallery_path)
        flash[:notice] = "Image was deleted."
      else
        redirect_back(fallback_location: business_logos_admin_gallery_path)
        flash[:error] = "There was an error deleting the image."
      end

    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: business_logos_admin_gallery_path)
      flash[:error] = "There was an error deleting the image."
    end
  end

  private

  def set_record
    @record_id = params[:id]
  end

end
