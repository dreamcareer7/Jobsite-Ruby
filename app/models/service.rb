class Service < ApplicationRecord
  include MetadataHelper
  include HandleImpressions

  validates :name, :sub_category_id, presence: true, on: :create

  belongs_to :sub_category

  has_one :sponsor, as: :listing_owner
  has_one :category_metadata, as: :owner
  has_one :category, through: :sub_category

  has_many :follows, as: :follow_target
  has_many :business_services, dependent: :destroy
  has_many :businesses, through: :business_services
  has_many :banner_targets, as: :target_listing, dependent: :destroy
  has_many :banners, through: :banner_targets

  after_commit :update_index
  after_destroy :update_index

  accepts_nested_attributes_for :category_metadata, allow_destroy: true

  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors

  extend FriendlyId
  friendly_id :slug_candidates, use: :scoped, scope: :sub_category

  is_impressionable

  default_scope { includes(:translations) }
  scope :by_sub_category, ->(sub_category) { where(sub_category_id: sub_category.id) }
  scope :visible, -> { where(hidden: false).order(name: :asc) }
  scope :enabled, -> { where(disabled: false) }
  scope :sub_category_visible, -> { joins(:sub_category).where("sub_categories.hidden" => false) }
  scope :trending_services, -> { order(view_count_change: :desc).first(4) }
  after_commit :clear_cache

  def slug_candidates
    [:id, :name]
  end

  def update_index
    return if self.previous_changes.empty? && Service.exists?(self)
    IndexNewListingJob.perform_later
  end

  def active_businesses_in_city(city)
    self.businesses.by_city(city).active.count
  end

  def description(city)
    "#{I18n.t("phrases.the_best_meta")} #{self.name.capitalize} #{I18n.t("phrases.services_in").downcase} #{city.name.titleize}, #{city.country.name.titleize}. #{I18n.t("phrases.similar_services")}: #{self.sub_category.services.visible.limit(5).collect(&:name).join(", ")}."
  end

  private

  def clear_cache
    I18n.available_locales.each do |locale|
      Rails.cache.delete("#{Rails.env}_sub_category_services_#{sub_category_id}_#{locale}")
      Rails.cache.delete("#{Rails.env}_get_distinct_services_#{sub_category_id}_#{locale}")
    end
  end
end
