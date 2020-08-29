module Business::Breadcrumbs
  extend ActiveSupport::Concern

  def set_breadcrumbs
    return nil unless request.referer

    path = URI(request.referer).path
    referer = path.split("/")
    referer.shift(2)

    return nil if referer.first.nil?

    begin
      object_type = referer.first.classify.constantize
    rescue
      return nil
    end
    object_slug = referer.last

    begin
      constructed_object = object_type.friendly.find(object_slug)
    rescue
      return nil
    end

    if constructed_object.is_a?(Service)
      category = constructed_object.category
      sub_category = constructed_object.sub_category

      [{ name: category.name, url: category_path(category, city: @current_city.slug),
         count: category.active_businesses_in_city(@current_city) },
      { name: sub_category.name, url: sub_category_path(sub_category, city: @current_city.slug),
        count: sub_category.active_businesses_in_city(@current_city) },
      { name: constructed_object.name, url: path,
        count:constructed_object.active_businesses_in_city(@current_city) }]

    elsif constructed_object.is_a?(SubCategory)
      category = constructed_object.category

      [{ name: category.name, url: category_path(category, city: @current_city.slug),
         count: category.active_businesses_in_city(@current_city) },
      { name: constructed_object.name, url: sub_category_path(constructed_object, city: @current_city.slug),
        count: constructed_object.active_businesses_in_city(@current_city) }]

    elsif constructed_object.is_a?(Category)
      [{ name: constructed_object.name, url: category_path(constructed_object, city: @current_city.slug),
         count: constructed_object.active_businesses_in_city(@current_city) }]
    elsif constructed_object.is_a?(User)
      [{ name: "Profile", url: user_profile_index_path }]
    else
      nil
    end

  end

end

