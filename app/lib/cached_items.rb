class CachedItems
  def self.all_categories
    Rails.cache.fetch("#{Rails.env}_all_categories_#{I18n.locale}") {
      Category.order(created_at: :asc)
    }
  end

  def self.spec_cat
    Rails.cache.fetch("#{Rails.env}_spec_cat_new") {
      Category.where(name: "Specialists").first
    }
  end

  def self.get_cached_city(city)
    Rails.cache.fetch("#{Rails.env}_get_cached_city_#{city}_#{I18n.locale}") {
      City.unscoped.friendly.find(city.downcase)
    }
  end
  def self.all_country_cities(city)
  end

  def self.cached_sp_services(specialist)
    Rails.cache.fetch("#{Rails.env}_cached_sp_services_new_#{specialist.id}_#{I18n.locale}") {
      specialist.services.visible.shuffle.first(16).in_groups_of(4).to_a
    }
  end
  def self.popular_items(city)
    #Rails.cache.fetch("#{Rails.env}_popular_items_new_#{city.id}_#{I18n.locale}"){
    SubCategory.visible.includes(:category_metadata).popular_by_listing_count(city).first(4).to_a
    #}
  end

  def self.get_services_by_sub_category(sub_category_id)
    Rails.cache.fetch("#{Rails.env}_get_distinct_services_#{sub_category_id}_#{I18n.locale}") {
      SubCategory.find(sub_category_id).services.visible.distinct.to_a
    }
  end
  def self.category_types(category)
    Rails.cache.fetch("#{Rails.env}_cached_category_typesnw_#{category.id}_#{I18n.locale}") {
      ProjectType.appropriate_project_types(category).to_a
    }
  end
  def self.get_all_categories
    Rails.cache.fetch("#{Rails.env}_cached_all_site_categories_#{I18n.locale}") {
      Category.includes(:category_metadata, :translations, sub_categories: :category_metadata).order("sub_categories.name asc")
    }
  end
end
