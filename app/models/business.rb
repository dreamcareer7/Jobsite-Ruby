class Business < ApplicationRecord
  include Localise::UserDistance
  include VideoUrlHelper
  include ReviewStars
  include EmailHelper
  include SendgridContacts

  OUT_OF_RANGE = 201

  STANDARD = 2

  PREMIUM = 3

  FILTERS = {
    flagged: [:flagged, true],
    unverified: [:verified, false],
    verified: [:verified, true],
  }

  enum number_of_employees: [
    '1',
    '2-10',
    '11-50',
    '51-200',
    '201-500',
    '501-1,000',
    '1,001-5,000',
    '5,001-10,000',
    '10,000+'
  ]

  enum service_area: [
    'Internationally',
    'Nationally',
    'Regionally',
    'Locally'
  ]

  enum project_size: [
    'Small to Medium',
    'Medium to Large',
    'Large',
    'Mega'
  ]

  enum business_type: [
    'Business',
    'Establishment',
    'International Brand',
    'Company',
    'Limited Liability Company',
    'Joint Venture',
    'Corporation',
    'Publicly Listed Company',
    'Municipality',
    'Association',
    'Non Profit Organisation',
    'Retail Chain',
    'Brand',
    'Professional Freelancer',
    'Independent Contractor'
  ]

  enum business_class: [
    'Pioneer',
    'Industry leader',
    'Accomplished',
    'Up & Coming',
    'Startup',
  ]

  enum nb_projects_completed: [
    '0',
    '1+',
    '5+',
    '10+',
    '50+',
    '100+',
    '500+',
    '1000+'
  ]

  validates :name, presence: true, on: :create

  attr_accessor :sub_categories_chosen, :business_days_start, :business_days_end, :business_time, :license_expiration_date

  belongs_to :user

  has_one :business_contact
  has_one :social_links, as: :owner, dependent: :destroy
  has_one :photo_gallery, as: :owner, dependent: :destroy
  has_one :brand

  has_many :quotes
  has_many :reviews
  has_many :shortlists
  has_many :user_callbacks
  has_many :applied_to_projects
  has_many :favourites
  has_many :follows, as: :follow_target
  has_many :quote_requests
  has_many :team_members
  has_many :subscriptions
  has_many :review_replies
  has_many :projects
  has_many :project_type_joins, as: :owner, dependent: :destroy
  has_many :project_types, through: :project_type_joins
  has_many :hidden_resources, dependent: :destroy
  has_many :self_added_projects, dependent: :destroy
  has_many :admins, through: :business_admins
  has_many :business_admins
  has_many :business_services
  has_many :services, through: :business_services
  has_many :brand_subsidiaries
  has_many :business_certifications
  has_many :certifications, through: :business_certifications
  has_many :business_verifications
  has_many :verifications, through: :business_verifications
  has_many :locations, as: :owner, dependent: :destroy
  has_many :countries, through: :locations
  has_many :cities, through: :locations
  has_many :categories, through: :services
  has_many :sub_categories, through: :services
  has_many :hours_of_operation
  has_many :branch_hours_of_operation, through: :locations, source: :hours_of_operation
  has_many :admin_notifications, dependent: :destroy
  has_many :favorites, as: :favoratable

  has_many :outgoing_notifications, -> (business) { where(sending_user_id: business.id, sending_user_type: 'Business' )}, class_name: "Notification", foreign_key: :sending_user_id
  has_many :incoming_notifications, -> (business) { where(receiving_user_id: business.id, receiving_user_type: 'Business' )}, class_name: "Notification", foreign_key: :receiving_user_id
  has_many :outgoing_messages, -> (business) { where(sending_user_id: business.id, sending_user_type: 'Business' )}, class_name: "Message", foreign_key: :sending_user_id
  has_many :incoming_messages, -> (business) { where(receiving_user_id: business.id, receiving_user_type: 'Business' )}, class_name: "Message", foreign_key: :receiving_user_id

  has_attached_file :logo, :styles => { small: "40x40", medium: "64x64", listing: "100x100", large: "200x200" } , default_url: lambda { |target| "#{ target.instance.fallback_logo }"}
  has_attached_file :banner, :styles => { small: "300x600", listing_card: "600x600", large: "1600x1400" } , default_url: "missing/banner.png"

  validates_attachment_content_type :logo, :banner, :content_type => [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]

  accepts_nested_attributes_for :brand, reject_if: :all_blank
  accepts_nested_attributes_for :business_contact, reject_if: :all_blank
  accepts_nested_attributes_for :hours_of_operation, reject_if: proc { |a| a[:start_day].blank? }
  accepts_nested_attributes_for :services, reject_if: proc { |a| a[:name].blank? }
  accepts_nested_attributes_for :social_links, reject_if: proc { |a| a.blank? }
  accepts_nested_attributes_for :self_added_projects, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :team_members, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :certifications, reject_if: :all_blank, allow_destroy: true

  has_attached_file :profile_image, styles: { small: "64x64", medium: "100x100", large: "200x200" }, default_url: "default_photos/:style/missing.png"
  validates_attachment_content_type :profile_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  scope :no_location, -> { includes(:locations).where(locations: { id: nil } ) }
  scope :by_city, -> (city) { joins(:cities).where('cities.id' => city) }
  scope :by_country, -> (country) { joins(:countries).where('countries.id' => country) }
  scope :by_user, -> (user) { joins(:user).where('users.id' => user) }
  scope :by_category, -> (category) { joins(:categories).where('categories.id' => category) }
  scope :for_listing, -> { includes(:reviews, :business_certifications, :hours_of_operation, :locations, :user, certifications: [:translations, :country]) }
  scope :by_certification, -> (certification) { joins(:certifications).where('certifications.id' => certification) }
  scope :by_verification, -> (verification) { joins(:verifications).where('verifications.id' => verification) }
  scope :by_service, -> (service) { joins(:services).where('services.id' => service) }
  scope :by_sub_category, -> (sub_category) { joins(:sub_categories).where('sub_categories.id' => sub_category) }
  scope :by_project_types, -> (project_type) { joins(:project_types).where('project_types.id' => project_type) }
  scope :by_profile_completion, -> { order(profile_completion: :desc) }
  scope :group_by_verified, -> { includes(:user).group_by { |business| business.user ? 'verified' : 'unverified' } }
  scope :recommended, -> { joins(:subscriptions).merge(Subscription.where(subscription_type: [ "standard", "premium"] )) }
  scope :latest, -> { order(updated_at: :desc) }
  scope :verified, -> { joins(:user).distinct  }
  scope :unverified, -> { includes(:user).where("users.id" => nil) }
  scope :flagged, -> { where flagged: true }
  scope :pending, -> { where approved: false }
  scope :disabled, -> { where disabled: true }
  scope :active, -> { where disabled: false, approved: true }
  scope :trusted, -> { joins(:subscriptions).merge(Subscription.where(subscription_type: [ "standard", "premium"] )) }
  scope :search, -> (search) { joins(:user).where("business_translations.name ILIKE ? OR users.name ILIKE ?", "%#{search}%", "%#{search}%")}
  scope :sort_by_name, ->(direction) do
    order("name #{direction}, name #{direction}")
  end
  scope :new_businesses, -> { where.not(banner_file_name: nil).order(created_at: :desc) }
  scope :new_premium_businesses, -> { joins(:subscriptions).merge(Subscription.valid.new_premium).where.not(banner_file_name: nil) }
  scope :most_viewed, -> (limit) { joins(:impressions).group('businesses.id').order('count_all DESC').limit(limit).count }
  scope :most_favourites, -> (limit) { joins(:favourites).group('businesses.id').order('count_all DESC').limit(limit).count }
  scope :free, -> { select{ |business| !business.paid_user? } }
  scope :paid, -> { joins(:subscriptions).where("subscriptions.subscription_type = ? OR subscriptions.subscription_type = ? AND subscriptions.expiry_date >= ?", STANDARD, PREMIUM, Date.today.end_of_day ) }
  scope :has_banner, -> { where.not(banner_file_name: nil) }
  scope :has_logo, -> { where.not(logo_file_name: nil) }
  scope :prompt_renew_subscription_candidates, -> { paid.where("subscriptions.expiry_date >= ? AND subscriptions.expiry_date <= ?", 3.days.from_now.beginning_of_day, 3.days.from_now.end_of_day) }
  scope :prompt_upgrade_candidates, -> { where("businesses.created_at >= ? AND businesses.created_at <= ?", 7.days.ago.beginning_of_day, 7.days.ago.end_of_day).free }
  scope :prompt_update_profile_candidates, -> { where("businesses.updated_at >= ? AND businesses.updated_at <= ?", 30.days.ago.beginning_of_day, 30.days.ago.end_of_day) }
  scope :prompt_update_incomplete_profile_candidates, -> { where("businesses.created_at >= ? AND businesses.created_at <= ?", 14.days.ago.beginning_of_day, 14.days.ago.end_of_day).select{ |business| business.profile_completion <= 90 } }
  scope :prompt_inactive_candidates, -> { joins(:user).where("users.last_sign_in_at >= ? AND users.last_sign_in_at <= ?", 30.days.ago.beginning_of_day, 30.days.ago.end_of_day) }
  scope :prompt_outstanding_quote_requests_candidates, -> { select { |business| business.outstanding_quote_requests_for_day(7.days.ago) } }
  scope :new_since, -> (target) { where("businesses.created_at >= ?", target.days.ago) }

  before_create :setup_profile_associations
  after_commit :update_cached_ranking, :handle_video_url
  after_commit :update_profile_completion, :update_index, on: [:create, :update]
  after_destroy :update_index
  after_create :send_new_business_email, :update_sendgrid_contacts
  after_update :send_approval_email

  translates :name, :email, :description, :insurance_coverage, :business_hours, fallbacks_for_empty_translations: true
  globalize_accessors

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  is_impressionable

  def should_generate_new_friendly_id?
    self.changes.include?(:name)
  end

  def slug_candidates
    [
      :name,
      [:id, :name]
    ]
  end

  def setup_profile_associations
    self.build_photo_gallery
    self.build_social_links
  end

  def established_since
    self.years_of_establishment ? Date.today.year - self.years_of_establishment : "Coming soon..."
  end

  def city_country
    "#{self.cities.includes(:translations).first.name}, #{self.countries.first.name}" unless self.cities.blank?
  end

  def pending_projects
    self.quotes.where(status: "pending").map{ |quote| quote.project }
  end

  def shortlisted_projects
    self.quotes.where(status: "shortlisted").map{ |quote| quote.project }
  end

  def ongoing_projects
    self.quotes.where(status: "accepted").map{ |quote| quote.project if quote.project.project_status != "completed" }.compact
  end

  def completed_projects
    self.quotes.where(status: "accepted").map{ |quote| quote.project if quote.project.project_status == "completed" }.compact
  end

  def similar_businesses(city)
    businesses = Business.where.not(id: self.id).where.not(banner_file_name: nil).by_city(city)
    businesses.by_service(self.services).distinct
  end

  def average_review_score
    return 0 unless self.reviews.present?
    review_sum = self.reviews.inject(0){ |sum, review| sum + review.average_score }
    review_sum / self.count_reviews
  end

  def count_reviews
    self.reviews_count
  end

  def ranking
    return 0 if Review.count < 1
    self.average_review_score.to_f * ( self.count_reviews.to_f / Review.count.to_f / self.rankingboost.to_f )
  end

  def paid_user?
    self.standard? || self.premium?
  end

  def business_hours
    @weekday_hours = self.hours_of_operation.where(week_period: "weekday").first
    @weekend_hours = self.hours_of_operation.where(week_period: "weekend").first

    if @weekday_hours.present?
      weekday_hours_hash = {
        weekday_hours: {
          day_start: @weekday_hours.start_day,
          day_end: @weekday_hours.end_day,
          shift_one_start: @weekday_hours.shift_one_start,
          shift_one_end: @weekday_hours.shift_one_end,
          shift_two_start: @weekday_hours.shift_two_start,
          shift_two_end: @weekday_hours.shift_two_end
        }
      }
    end

    if @weekend_hours.present?
      weekend_hours_hash = {
        weekend_hours: {
          day_start: @weekend_hours.start_day,
          day_end: @weekend_hours.end_day,
          shift_one_start: @weekend_hours.shift_one_start,
          shift_one_end: @weekend_hours.shift_one_end,
          shift_two_start: @weekend_hours.shift_two_start,
          shift_two_end: @weekend_hours.shift_two_end
        }
      }
    end

    if weekday_hours_hash.present? && weekend_hours_hash.present?
      weekday_hours_hash.merge(weekend_hours_hash)
    elsif weekday_hours_hash.present?
      weekday_hours_hash
    elsif weekend_hours_hash.present?
      weekend_hours_hash
    else
      "Information not available"
    end

  end

  def rankingboost
    if self.premium?
      0.6
    elsif self.standard?
      0.8
    else
      1
    end
  end

  def subscription_type
    if self.premium?
      'premium'
    elsif self.standard?
      'standard'
    else
      'free'
    end
  end

  def distance_from_user(city, user_coords)
    return 0.0 unless self.locations.present?
    business_location = self.locations.where(city: city).first
    return 0.0 unless business_location.present?

    business_coords = "#{ business_location.latitude}, #{ business_location.longitude }"

    distance(business_coords, user_coords)
  end

  def distance_from_user_to_s(coordinates, city)
    coordinates.present? ? self.distance_from_user(city, coordinates).round(1) : ''
  end

  def shortlisted?(project)
    self.shortlists.where(project_id: project.id).exists?
  end

  def claimed?
    self.user.present?
  end

  def standard?
    self.subscriptions.valid.any?{ |subscription| subscription.subscription_type == "standard" }
  end

  def premium?
    self.subscriptions.valid.any?{ |subscription| subscription.subscription_type == "premium" }
  end

  def trusted?
    self.standard? || self.premium?
  end

  def account_type
    return "Not a member" if !self.claimed?
    return "Premium" if self.premium?
    return "Standard" if self.standard?
    return "Free"
  end

  def flagged?
    self.flagged
  end

  def verified?
    self.user.present?
  end

  def shortlisted_or_accepted?(project)
    project.shortlists.where(business_id: self.id).present? || project.business == self
  end

  def update_cached_ranking
    return if self.previous_changes.empty?
    CacheBusinessRankingJob.perform_later(self)
  end

  def update_index
    return if self.previous_changes.empty? && Business.exists?(self)
    IndexNewListingJob.perform_later
  end

  def unread_notifications
    self.incoming_notifications.where(read: false) + self.incoming_messages.where(read: false)
  end

  def category_list
    self.categories
  end

  def has_category?(category)
    self.category_list.any?{ |chosen_category| chosen_category == category }
  end

  def messages
    Message.where(sending_user_id: self.id, sending_user_type: "Business").or(Message.where(receiving_user_id: self.id, receiving_user_type: "Business")).where(project_id: nil)
  end

  def conversations
    Conversation.where(user_one_id: self.id, user_one_type: "Business").or(Conversation.where(user_two_id: self.id, user_two_type: "Business"))
  end

  def contact_photo
    return self.business_contact.profile_image.url if self.business_contact.present?
    "missing/contact.png"
  end

  def location_for_to_s(city)
    if self.locations.present?
      self.locations.by_city(city).present? ? self.locations.by_city(city).city_country : self.locations.first.city_country
    else
      ""
    end
  end

  def experience
    if self.years_of_establishment.present? && self.years_of_establishment > 1000
      Date.today.year - self.years_of_establishment
    else
      "0"
    end
  end

  def master_category
    self.categories.group(:id).order(:count).reverse.first
  end

  def sub_categories_where_no_service
    self.services.sub_category_visible.group_by(&:sub_category)
    .select{ |sub, services| services.count == 1 && services.first.name == "None" }
    .keys
    .pluck(:id)
  end

  def fallback_logo
    if self.master_category.present?
      "icons/fallback/#{ I18n.with_locale(:en){ master_category.name.downcase } }.png"
    else
      "listings/logo.png"
    end
  end

  def headquarters
    self.locations.where(location_type: "Headquarters").first
  end

  def number_for_city(city)
    numbers_for_city = self.locations.where(city: city).where.not(number: nil)
    headquarters = numbers_for_city.where(location_type: "Headquarters").where.not(number: nil).first

    if numbers_for_city.present?
      headquarters.present? ? headquarters.number : numbers_for_city.first.number
    else
      self.telephone
    end

  end

  def update_profile_completion
    return if self.previous_changes.empty?

    fields_for_complete_profile = [
      self.name,
      self.min_budget,
      self.max_budget,
      self.years_of_establishment,
      self.number_of_employees,
      self.license_number,
      self.nb_projects_completed,
      self.email,
      self.telephone,
      self.hours_of_operation,
      self.logo,
      self.banner,
      self.description,
      self.website,
      self.business_contact,
      self.cities,
      self.services,
    ]

    completed = (
      ((fields_for_complete_profile.count(&:present?).to_f /
        fields_for_complete_profile.count.to_f) * 100)
      .round)

    self.update(profile_completion: completed)
  end


  def hours_for(period)
    self.hours_of_operation.where(week_period: period)
  end

  def business_upgraded(subscription)
    send_business_upgraded_email(subscription)
  end

  def outstanding_quote_requests_for_day(date)
    projects = Project
      .where(id: self.quote_requests
      .where("created_at >= ? AND created_at <= ?", date.beginning_of_day, date.end_of_day)
      .pluck(:project_id)).where(project_status: :new_project)

    outstanding = projects.select do |project|
      !project.applied_to_projects.pluck(:business_id).include?(self.id) &&
        !project.shortlists.pluck(:business_id).include?(self.id) &&
        !self.hidden_resources.pluck(:project_id).include?(project.id)
    end

    outstanding.present?
  end

  def send_approval_email
    return unless self.changed.include?("approved") && self.approved

    send_business_approved_email(self)
  end

  private

  class << self

    def active?
      Business.where(disabled: false)
    end

    def sort_by_reviews_score
      Business.includes(:reviews).sort_by{ |business| business.average_review_score }.reverse
    end

    def sort_by_status
      Business.includes(:subscriptions).partition{ |business| business.verified? && business.trusted? }.reduce(:+)
    end

    def sort_by_reviews_and_status
      Business.includes(:reviews, :subscriptions).sort_by{ |business| business.average_review_score }
      .reverse.partition{ |business| business.verified? && business.trusted? }.reduce(:+)
    end
  end

  def nullify_slug
    self.slug = nil
  end

  def update_sendgrid_contacts
    # only add contacts on prod
    prepare_business_contact(self) if ENV["DOMAIN"] == "muqawiloon.com"
  end

end
