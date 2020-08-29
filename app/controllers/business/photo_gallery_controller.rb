class Business::PhotoGalleryController < Business::BaseController

  def new
    @photo_gallery = PhotoGallery.new
  end


  def create
    @photo_gallery = @project.photo_gallery.create(photo_gallery_params)

    if @photo_gallery.save
    else
      render :new
    end
  end

  def edit
    @photo_gallery = PhotoGallery.find(params[:id])
  end

  def update
    @photo_gallery = PhotoGallery.find(params[:id])

    if params[:photo_gallery].present?
      photos = params[:photo_gallery][:photos]
      photos.each{ |photo| @photo_gallery.photos.create(photo: photo) }
    end

    redirect_to business_profile_index_path(business: @photo_gallery.owner.id)
  end

  def show
    @business = Business.find(params[:id])
    @business.photo_gallery
  end

  def photo_gallery_params
    params.require(:photo_gallery).permit(:photo)
  end

  private

  def photo_gallery_params
    params.require(:photo_gallery).permit(photos:[:photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :photo_gallery_id, :photo])
  end

end

