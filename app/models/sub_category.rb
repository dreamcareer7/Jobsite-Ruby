class SubCategory < ApplicationRecord
  include MetadataHelper
  include HandleImpressions

  validates :name, :category_id, presence: true

  belongs_to :category

  has_one :sponsor, as: :listing_owner
  has_one :category_metadata, as: :owner

  has_many :follows, as: :follow_target
  has_many :services, dependent: :destroy
  has_many :businesses, -> { distinct }, through: :services
  has_many :banner_targets, as: :target_listing
  has_many :banners, through: :banner_targets

  accepts_nested_attributes_for :category_metadata, allow_destroy: true

  after_create :create_none_service
  after_commit :clear_cache
  is_impressionable

  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors

  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :category

  default_scope { includes(:translations) }
  scope :trending, -> { includes(:category_metadata).order(view_count_change: :desc) }
  scope :by_category, ->(category) { joins(:category).where("categories.id" => category) }
  scope :visible, -> { where(hidden: false).order(name: :asc) }
  scope :enabled, -> { where(disabled: false) }

  def self.cached_trending
    Rails.cache.fetch("#{Rails.env}_cached_trendingn_#{I18n.locale}") {
      includes(:category_metadata).order(view_count_change: :desc).to_a
    }
  end

  def cached_visible_services
    Rails.cache.fetch("#{Rails.env}_sub_category_services_#{id}_#{I18n.locale}") {
      services.visible
    }
  end

  def active_businesses_in_city(city)
    Rails.cache.fetch("#{Rails.env}_subcat_#{id}_active_businesses_in_city_#{city.id}_#{I18n.locale}") {
      self.businesses.active.by_city(city).count
    }
  end

  def slug_candidates
    [
      :name,
      [:id, :name],
    ]
  end

  def self.popular_by_listing_count(city)
    Rails.cache.fetch("#{Rails.env}_popular_by_listing_#{city.id}_#{I18n.locale}") {
      by_listing_count = SubCategory.includes(:businesses).to_a.sort_by do |sub_category|
        sub_category.active_businesses_in_city(city)
      end

      by_listing_count.reverse!
    }
  end

  def description(city)
    "#{I18n.t("phrases.the_best_meta")} #{self.name} #{I18n.t("phrases.services_in")} #{city.name.titleize}, #{city.country.name.titleize}. #{I18n.t("words.including")}: #{self.services.visible.limit(5).collect(&:name).join(", ")}."
  end

  private

  def clear_cache
    I18n.available_locales.each do |locale|
      Rails.cache.delete("#{Rails.env}_cached_trendingn_#{locale}")
      Rails.cache.delete("#{Rails.env}_2visible_sub_categories_enabled_#{category_id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_get_distinct_services_#{id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_sub_category_services_#{id}_#{locale}")

      Rails.cache.delete("#{Rails.env}_visible_sub_categories_#{category_id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_cached_all_site_categories_#{locale}")
      if category.present?
        Rails.cache.delete("#{Rails.env}_supplier_sub_caegory_#{self.category.name}_#{locale}")
      end
    end
  end

  def create_none_service
    self.services.create(name: "None", hidden: true)
  end
end
