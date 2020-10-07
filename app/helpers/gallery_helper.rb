module GalleryHelper
  def gallery_tile_title(owner)
    return owner.title if owner.is_a?(Project) || owner.is_a?(SelfAddedProject)
  end

  def gallery_tile_company(owner)
    if owner.is_a?(Project)
      owner.user.name
    elsif owner.is_a?(SelfAddedProject)
      owner.business.name
    elsif owner.is_a?(Business)
      owner.name
    end
  end
end
