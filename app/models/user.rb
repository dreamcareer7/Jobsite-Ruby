class User < ApplicationRecord
  include EmailHelper
  include SendgridContacts

  attr_accessor :country_for_select

  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :linkedin]

  validates :name, :email, :password, presence: true, on: :create

  has_one :location, as: :owner, dependent: :destroy
  has_one :city, through: :location
  has_one :country, through: :location
  has_one :photo_gallery, as: :owner, dependent: :destroy

  has_many :reviews
  has_many :favorites
  has_many :follows
  has_many :favorites
  has_many :businesses
  has_many :followed_businesses, through: :follows, source: :follow_target, source_type: "Business"
  has_many :favourites
  has_many :subscriptions
  has_many :user_callbacks
  has_many :quote_requests, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :outgoing_notifications, -> (user) { where(sending_user_id: user.id, sending_user_type: 'User' )}, class_name: "Notification", foreign_key: :sending_user_id
  has_many :incoming_notifications, -> (user) { where(receiving_user_id: user.id, receiving_user_type: 'User' )}, class_name: "Notification", foreign_key: :receiving_user_id
  has_many :outgoing_messages, -> (user) { where(sending_user_id: user.id, sending_user_type: 'User' )}, class_name: "Message", foreign_key: :sending_user_id
  has_many :incoming_messages, -> (user) { where(receiving_user_id: user.id, receiving_user_type: 'User' )}, class_name: "Message", foreign_key: :receiving_user_id
  has_many :admin_notifications, dependent: :destroy

  has_many :followed_businesses, through: :follows, source: :follow_target, source_type: "Business"
  has_many :followed_categories, through: :follows, source: :follow_target, source_type: "Category"
  has_many :followed_sub_categories, through: :follows, source: :follow_target, source_type: "SubCategory"
  has_many :followed_services, through: :follows, source: :follow_target, source_type: "Service"

  has_attached_file :profile_image, style: { small: "64x64", large: "100x100" } , default_url: "missing/contact.png"
  validates_attachment_content_type :profile_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

  after_create :set_default_profile, :set_subscription, :update_sendgrid_contacts
  after_commit :update_profile_completion, on: [:create, :update]

  FREE_USER_QUOTE_REQUEST_LIMIT = 2
  FREE_USER_QUOTE_REQUEST_REFRESH = 2.days.ago
  PRO = 1

  enum industry: [
    :administrative,
    :advertising_and_marketing,
    :air_travel,
    :art_and_design,
    :automotive,
    :banking,
    :building_and_construction,
    :business_development,
    :consulting,
    :corporate,
    :customer_service,
    :distribution_and_logistics,
    :e_commerce,
    :education,
    :entrepreneur,
    :farming_and_agriculture,
    :fashion,
    :fmcg_and_retail,
    :food_services,
    :government_services,
    :graduate,
    :health_and_wellness,
    :human_resources,
    :information_technology,
    :insurance,
    :law_enforcement,
    :legal,
    :manufacturing,
    :media_communications,
    :media_production,
    :medical_services,
    :municipal_services,
    :other,
    :pharmacuetical,
    :public_relations,
    :purchasing,
    :restaurant_and_hospitality,
    :sales,
    :sports_and_events,
    :student,
    :technology_development,
    :tourism_and_leisure,
    :transportation,
    :unemployed
  ]

  scope :vendors, -> { joins(:businesses).uniq }
  scope :paid, -> { joins(:subscriptions).where("subscriptions.subscription_type = ? AND subscriptions.expiry_date >= ?", PRO, Date.today.end_of_day ).distinct }
  scope :free, -> { select{ |user| !user.pro? } }
  scope :prompt_upgrade_candidates, -> { where("users.created_at >= ? AND users.created_at <= ?", 14.days.ago.beginning_of_day, 14.days.ago.end_of_day).free }
  scope :prompt_update_profile_candidates, -> { where("users.created_at >= ? AND users.created_at <= ?", 7.days.ago.beginning_of_day, 7.days.ago.end_of_day).select{ |user| user.profile_completion <= 60 } }
  scope :prompt_renew_subscription_candidates, -> { paid.where("subscriptions.expiry_date >= ? AND subscriptions.expiry_date <= ?", 3.days.from_now.beginning_of_day, 3.days.from_now.end_of_day) }
  scope :following_candidates, -> { joins(:follows).where.not(browse_location: nil) }
  scope :with_businesses, -> { joins(:businesses).distinct }
  scope :without_businesses, -> { includes(:businesses).where("businesses.id" => nil) }
  scope :new_since, -> (target) { where("users.created_at >= ?", target.days.ago) }

  def first_name
    self.name.split(" ").first
  end

  def last_name
    self.name.split(" ").last
  end

  def quote_requests_pending_two_days?
    quote_requests = self.quote_requests.by_status("pending")
    .order(created_at: :desc).limit(FREE_USER_QUOTE_REQUEST_LIMIT)

    quote_requests.any? { |quote_request| quote_request.created_at < FREE_USER_QUOTE_REQUEST_REFRESH }
  end

  def pro?
    self.subscriptions.valid.any?{ |subscription| subscription.subscription_type == "pro" }
  end

  def free?
    self.subscriptions.where.not(subscription_type: "free" ).empty?
  end

  def paid_user?
    self.pro?
  end

  def city_country
    self.city.present? && self.country.present? ? "#{self.city.name}, #{self.country.name}" : ""
  end

  def unread_notifications
    self.incoming_notifications.where(read: false) + self.incoming_messages.where(read: false)
  end

  def conversations
    Conversation.where(user_one_id: self.id, user_one_type: "User").or(Conversation.where(user_two_id: self.id, user_two_type: "User"))
  end

  def unread_business_notifications
    return unless self.businesses.present?

    unread = self.businesses.reduce(0) do |total, business|
      total += business.unread_notifications.count
    end

    unread > 0 ? unread : ""
  end

  def total_unread_notifications
    unread_business = unread_business_notifications.present? ? unread_business_notifications : 0
    total_unread = unread_business + unread_notifications.count

    total_unread > 0 ? total_unread : ""
  end

  def required_fields_present?
    true
    #return false unless self.encrypted_password.present?
    #return false unless self.mobile_number.present?

    #true
  end

  def get_omniauth_image(image_url)
    return unless self.profile_image.blank?
    return unless image_url.present?

    #http://stackoverflow.com/questions/9848543/rails-retrieving-image-from-facebook-after-omniauth-login-with-devise
    if image_url.starts_with?("http:")
      image_url = image_url.gsub("http", "https")
    end

    begin
      self.profile_image = URI.parse(image_url).open
      self.save
    rescue
      return
    end

  end

  def update_profile_completion
    return if self.previous_changes.empty?

    fields_for_complete_profile = [
      self.name,
      self.profile_image,
      self.mobile_number,
      self.nationality,
      self.industry,
      self.birthday,
      self.email,
      self.encrypted_password
    ]

    completed = (
      ((fields_for_complete_profile.count(&:present?).to_f /
        fields_for_complete_profile.count.to_f) * 100)
      .round)

    self.update(profile_completion: completed)
  end

  def after_confirmation
    send_welcome_email
    send_business_model_email
  end

  def user_upgraded(subscription)
    send_user_upgraded_email(subscription)
  end

  private

  def set_default_profile
    self.update_attributes(default_profile: self.id)
  end

  def set_subscription
    self.subscriptions.create(subscription_type: "free")
  end

  def update_sendgrid_contacts
    # only add contacts on prod

    prepare_user_contact(self) if ENV["DOMAIN"] == "muqawiloon.com"
  end

  def self.from_omniauth(auth)
    oauth_user = User.find_or_initialize_by(email: auth.info.email) do |user|
      user.name ||= auth.info.name
      user.password ||= nil
    end

    oauth_user.confirm!
    oauth_user.save(validate: false) if oauth_user.new_record?

    oauth_user
  end

end
