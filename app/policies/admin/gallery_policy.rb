class Admin::GalleryPolicy < ApplicationPolicy

  def index?
    @user.superadmin? || @user.data_manager?
  end

  def business_banners?
    index?
  end

  def user_projects?
    index?
  end

  def business_projects?
    index?
  end

  def destroy_video_link?
    index?
  end

  def destroy_business_image?
    index?
  end

  def destroy_attachment?
    index?
  end

  def destroy_banner?
    index?
  end

end

