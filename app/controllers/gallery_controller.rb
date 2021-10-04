class GalleryController < ApplicationController

  def index

    @user_project_photos = user_project_photos
    @business_projects = business_projects
    @business_banners = business_banners
    @gallery_items = @user_project_photos + @business_projects + @business_banners
    #@gallery_items =  @business_banners 

    @sorted_items = @gallery_items.reject{ |item| item.created_at.blank?}.sort_by do |item|
      item.created_at
    end

    @gallery_items = Kaminari.paginate_array(@sorted_items.reverse!).page(params[:page]).per(12)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def category_filter_present?
    params[:category_type].present?
  end

  def user_project_photos
    if category_filter_present?
      Attachment.by_city(@current_city).by_category(category.id)
    else
      Attachment.by_city(@current_city).project_images
    end
  end

  def business_banners
    if category_filter_present?
      Business.active.joins(:services).where(services: {sub_category_id: category_ids }).by_city(@current_city).has_banner.distinct
    else
      Business.active.by_city(@current_city).has_banner.distinct
    end
  end

  def business_projects
    if category_filter_present?
      SelfAddedProject.joins(:services).where(services: {sub_category_id: category_ids }).by_city(@current_city).has_photos.distinct
    else
      SelfAddedProject.by_city(@current_city).has_photos.distinct
    end
  end

  def category_ids
    @category_ids ||= if %w(machinery interior_design).include?(params[:category_type])
                        category.sub_categories.pluck(:id)
                      else
                        category.sub_categories.where(slug: params[:category_type]).pluck(:id)
                      end
  end

  def category
    return @category if @category.present?

    if %w(machinery interior_design).include?(params[:category_type])
      category_slug  = params[:category_type] == "interior_design" ? "consultants" : "machinery"
      @category = Category.find_by(slug: category_slug)
    else
      @category = Category.find_by(slug: "suppliers")
    end
  end
end
