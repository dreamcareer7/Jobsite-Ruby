module MetadataHelper
  include ActionView::Helpers::TextHelper

  def headline(current_city, filter="")
    "#{ self.sub_category.name.capitalize + ' - ' if self.is_a?(Service) } #{ self.name.capitalize } #{ I18n.t("words.in") } #{ current_city.name.titleize } | #{ I18n.t('phrases.listing_results', business_count: self.active_businesses_in_city(current_city)) }"
  end

  def business_headline(city, filter="")
    "#{ I18n.t("phrases.the_best") } #{ city.name.titleize }, #{ city.country.name.titleize }"
  end

  def sub_headline(current_city) 
    return self.category_metadata.subheadline if self.category_metadata.present? && self.category_metadata.subheadline.present?

    if [Category, SubCategory].member?(self.class)
      "#{ I18n.t('listing.cat_headline', cat_name: self.name.titleize, city_name: current_city.name.capitalize) } "
    elsif self.is_a?(Service)
      "#{ I18n.t('listing.service_headline', cat_name: self.category.name.titleize, service_name: self.name.capitalize, city_name: current_city.name.capitalize) } "
    end

  end

  def metadata_banner
    return "" unless self.category_metadata.present?

    self.category_metadata.banner if self.category_metadata.banner.present?
  end

  def filter_to_s(filter)
    return I18n.t("words.recommended").titleize unless filter.present?

    case filter
    when "Recommended"
      filter_name = I18n.t("words.recommended")
    when "Latest"
      filter_name = I18n.t("words.latest")
    when "Distance"
      filter_name = I18n.t("words.closest")
    when "Verified"
      filter_name = I18n.t("words.verified")
    else
      filter_name = I18n.t("words.recommended")
    end

    return filter_name.titleize
  end

end
