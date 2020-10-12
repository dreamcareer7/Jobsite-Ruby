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

  def gallery_item_slug(owner)
    if owner.is_a?(SelfAddedProject)
      owner.business.slug
    elsif owner.is_a?(Business)
      owner.slug
    end
  end

  def business_share_url(owner)
    business_url(id: gallery_item_slug(owner), city: @current_city.slug)
  end

  def fb_share_url(owner)
    "https://www.facebook.com/sharer.php?u=" + business_share_url(owner)
  end

  def twitter_share_url(owner)
    "https://twitter.com/share?url" + business_share_url(owner)
  end

  def whatsapp_share_url(owner)
    "https://api.whatsapp.com/send?text=" + business_share_url(owner)
  end

  def linkedin_share_url(owner)
    "https://www.linkedin.com/shareArticle?url=" + business_share_url(owner)
  end

  def google_share_url(owner)
    "https://plus.google.com/share?url=" + business_share_url(owner)
  end

  def like_gallery_button(item)
    if current_user && has_liked_item?(item)
      link_to content_tag(:i, "", class: "fa fa-heart", "aria-hidden": true), user_like_gallery_path(item, favoratable_id: item.id,favoratable_type: item.class.name), method: :delete, remote: true
    elsif current_user
      link_to content_tag(:i, "", class: "fa fa-heart-o", "aria-hidden": true), user_like_gallery_index_path(favoratable_id: item.id, favoratable_type: item.class.name), method: :post, remote: true
    else
      content_tag(:i, "", class: "fa fa-heart-o js-open-modal", "aria-hidden": true, "data-modal": "log-in")
    end
  end

  def has_liked_item?(item)
    liked_items.select { |liked_item| liked_item.favoratable_id == item.id && liked_item.favoratable_type == item.class.name}.present?
  end

  def liked_items
    @liked_items ||= current_user.favorites
  end

  def gallery_categories
    [["gallery.machinery", "machinery"], ["gallery.interior_design", "interior_design"],
    ["gallery.furniture", "furniture"], ["gallery.tool_and_hardware", "tools-and-hardware"],
    ["gallery.building_materials", "building-materials"]]
  end
end
