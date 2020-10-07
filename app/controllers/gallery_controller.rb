class GalleryController < ApplicationController

  def index
    @user_project_photos = Attachment.by_city(@current_city).project_images
    @business_projects = SelfAddedProject.by_city(@current_city).has_photos.distinct
    @business_banners = Business.active.by_city(@current_city).has_banner.distinct
    @gallery_items = @user_project_photos + @business_projects + @business_banners

    @sorted_items = @gallery_items.reject{ |item| item.created_at.blank?}.sort_by do |item|
      item.created_at
    end

    @gallery_items = Kaminari.paginate_array(@sorted_items.reverse!).page(params[:page]).per(12)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
