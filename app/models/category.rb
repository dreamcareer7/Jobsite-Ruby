class Category < ApplicationRecord
  include MetadataHelper

  validates :name, presence: true

  has_one :category_metadata, as: :owner

  has_one :sponsor, as: :listing_owner
  has_many :projects
  has_many :follows, as: :follow_target
  has_many :sub_categories, dependent: :destroy
  has_many :services, through: :sub_categories
  has_many :businesses, -> { distinct }, through: :services
  has_many :banner_targets, as: :target_listing
  has_many :banners, through: :banner_targets

  accepts_nested_attributes_for :category_metadata, allow_destroy: true

  after_create :create_none_sub_category
  after_commit :clear_cache
  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors

  default_scope { includes(:translations) }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def cached_all_services
    Rails.cache.fetch("#{Rails.env}_cachedAllServices_#{id}_#{I18n.locale}") {
      services
    }
  end

  def cached_subcategories_enabled
    Rails.cache.fetch("#{Rails.env}_2visible_sub_categories_enabled_#{id}_#{I18n.locale}") {
      sub_categories.visible.enabled
    }
  end

  def cached_subcategories
    Rails.cache.fetch("#{Rails.env}_visible_sub_categories_#{id}_#{I18n.locale}") {
      sub_categories.visible
    }
  end

  def slug_candidates
    [
      :name,
      [:id, :name],
    ]
  end

  def name_to_singular
    self.name.singularize
  end

  def popular_services
    self.services.visible.order(view_count: :desc).first(5)
  end

  def active_businesses_in_city(city)
    Rails.cache.fetch("#{Rails.env}_cat_#{id}_active_businesses_in_city_#{city.id}_#{I18n.locale}") {
      self.businesses.by_city(city).active.count
    }
  end

  def description(city)
    "#{I18n.t("phrases.the_best_meta")} #{self.name} #{I18n.t("words.in").downcase} #{city.name}, #{I18n.t("words.including")}: #{Category.all.collect(&:name).join(", ")}."
  end

  def category_type
    if I18n.with_locale(:en) { self.name } == "Machinery"
      :machinery
    elsif I18n.with_locale(:en) { self.name } == "Suppliers"
      :supplier
    else
      :professional
    end
  end

  def category_head_description
    return [self.category_metadata.description] if self.category_metadata.present? && self.category_metadata.description.present?
    if self.name == "Consultants"
      return ["Architects", "Engineer", "Designers"]
    elsif self.name == "Contractors"
      return ["Construction", "Builders", "Mechanicals"]
      #elsif self.name == "Municipal"
      #TODO: fix it
      # return [""]
    elsif self.name == "Specialists"
      return ["Plumber", "Painters", "Carpenters"]
    elsif self.name == "Machinery"
      return ["Heavy Machinery", "Trucks", "Road"]
    elsif self.name == "Suppliers"
      return ["Tools & Hardware", "Building Mateirals"]
    else
      return ["Architects", "Engineer", "Designers"]
    end
  end

  private

  def clear_cache
    I18n.available_locales.each do |locale|
      Rails.cache.delete("#{Rails.env}_cachedAllServices_#{id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_suppliers_sub_caty_#{slug}_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_trendingn_#{locale}")
      Rails.cache.delete("#{Rails.env}_2visible_sub_categories_enabled_#{id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached__by_n_category_type_#{category_id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_by_category_type_#{id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_visible_sub_categories_#{id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_all_site_categories_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_sp_services_new_#{id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_supplier_sub_caegory_#{name}_#{locale}")
      Rails.cache.delete("#{Rails.env}_all_categories_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_category_types_#{id}_#{locale}")
    end
  end

  def self.description(city)
    "#{I18n.t("phrases.the_best_meta")} #{I18n.t("words.categories")} #{I18n.t("words.in").downcase} #{city.name}, #{I18n.t("words.including")}: #{Category.all.collect(&:name).join(", ")}."
  end

  def create_none_sub_category
    self.sub_categories.create(name: "None", hidden: true)
  end

  class << self
    def order_by_type
      ordered = self.order(:name).to_a
      machinery_index = ordered.find_index do |category|
        I18n.with_locale(:en) { category.name == "Machinery" }
      end

      return ordered unless machinery_index

      ordered.insert(-1, ordered.delete_at(machinery_index))
    end
  end
end
