class Project < ApplicationRecord
  include Localise::UserDistance
  include EmailHelper

  attr_accessor :attachment, :required_category, :project_sub_category

  OUT_OF_RANGE = 101

  enum location_class: [
    :commercial,
    :residential,
    :government,
    :industrial
  ]

  enum contact_role: [
    :agent,
    :ceo,
    :employee,
    :general_manager,
    :marketing_manager,
    :owner,
    :other,
    :project_consultant,
    :project_manager,
    :project_owner
  ]

  enum project_budget: [
    '0 - 499',
    '500 - 1,999',
    '2,000 - 9,999',
    '10,000 - 49,999',
    '50,000 - 199,999',
    '200,000 - 1,000,000',
    '1,000,000 +',
    :open
  ]

  enum timeline_type: [
    :flexible,
    :urgent
  ]

  enum currency_type: [
    :american_dollar,
    :bahrain,
    :british_pound,
    :egyptian_pound,
    :jordan,
    :kuwaiti_dinar,
    :omani_riyal,
    :qatar,
    :turkey,
    :saudi_riyal,
    :uae_dirham
  ]

  enum project_status: [
    :new_project,
    :in_process,
    :completion_pending,
    :completed,
    :cancelled
  ]

  belongs_to :user
  belongs_to :business
  belongs_to :category

  has_one :location, as: :owner
  has_one :city, through: :location
  has_one :country, through: :location
  has_one :review, dependent: :destroy

  has_many :quotes
  has_many :messages
  has_many :notifications
  has_many :applied_to_projects
  has_many :shortlists
  has_many :project_type_joins, as: :owner, dependent: :destroy
  has_many :project_types, through: :project_type_joins
  has_many :quote_requests
  has_many :services, through: :project_services
  has_many :hidden_resources, dependent: :destroy
  has_many :sub_categories, through: :services
  has_many :project_services, dependent: :destroy
  has_many :attachments, as: :owner, dependent: :destroy
  has_many :admin_notifications, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :project_services, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :project_types, reject_if: :all_blank, allow_destroy: true

  validates :historical_structure, inclusion: { in: [true, false] }, if: :active_or_project_details? && "historical_structure.present?"

  #validate before moving from first step of form
  validates :title, :description, :user, :start_date, :end_date, presence: :true, if: :active_or_project_details?

  translates :title, :description, :location_type, :project_owner_type, fallbacks_for_empty_translations: true

  scope :by_city, -> (city) { joins(location: :city).where('cities.id' => city) }
  scope :by_services, -> (service) { joins(:services).where('services.id' => service) }
  scope :by_sub_categories_no_service, -> (sub_categories) { joins(:services).where('services.sub_category_id' => sub_categories) }
  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }
  scope :not_hidden, -> (hidden_resources) { where.not(id: hidden_resources) }
  scope :not_applied, -> (applied_projects) { where.not(id: applied_projects) }
  scope :not_completed_or_accepted, -> { where.not(project_status: :completed).where(business_id: nil) }
  scope :has_images, -> { joins(:attachments) }
  scope :prompt_check_quotes_candidates, -> { where(project_status: :new_project).joins(:quotes).where("quotes.created_at >= ? AND quotes.created_at <= ?", 7.days.ago.beginning_of_day, 7.day.ago.end_of_day) }
  scope :prompt_list_of_businesses_email_candidates, -> { where(project_status: :new_project).where("created_at >= ? AND created_at <= ?", 7.days.ago.beginning_of_day, 7.day.ago.end_of_day) }
  scope :new_since, -> (target) { where("projects.created_at >= ?", target.days.ago) }

  after_create :generate_reference_number

  def project_batch
    ProjectBatch.where("project1 = ? OR project2 = ? OR project3 = ?", self.id, self.id, self.id).first
  end

  def city_country
    "#{self.city.name}, #{self.country.name}" unless self.city.blank?
  end

  def display_services
    if self.services.count <= 2
      "#{self.services.visible.map(&:name).join(", ")}"
    else
      "#{self.services.visible.first(2).map(&:name).join(", ")} and #{self.services.count - 2 } more"
    end
  end

  def images
    self.attachments.select{ |attachment| attachment.is_image? }
  end

  def status_to_s
    I18n.t("project_status.#{ self.project_status }")
  end

  ## Statuses

  def update_status(status)
    self.update_attributes(project_status: status)
  end

  def active?
    self.creation_status == "active"
  end

  def pending_completion?
    self.project_status == "completion_pending"
  end

  def project_in_process?
    self.project_status == "in_process" || self.project_status == "completion_pending"
  end

  def completed?
    self.project_status == "completed"
  end

  def cancelled?
    self.project_status == "cancelled"
  end

  def cancelled_by_business?
    self.project_status == "cancelled" && self.business_id != nil
  end

  def active_or_project_details?
    (creation_status && creation_status.include?('project_details')) || active?
  end

  def inactive?
    self.completed? || self.cancelled?
  end

  def hired?
    self.business_id != nil
  end

  ## Counts

  def number_applied
    self.applied_to_projects.where.not(business_id: self.shortlists.pluck(:business_id)).count
  end

  def number_shortlisted
    self.shortlists.present? ? self.shortlists.count : 0
  end

  ## Business actions

  def suggested_businesses
    #base matching
    businesses = Business.by_city(self.location.city).by_category(self.category)

    by_sub_category = businesses.by_sub_category(self.sub_categories)
    by_project_types = businesses.by_project_types(self.project_types)

    suggested = by_project_types + by_sub_category + businesses

    suggested.uniq
  end

  def distance_from_business(business_coords)
    return OUT_OF_RANGE if self.location.to_coordinates.include? nil

    distance(business_coords, self.location.to_coordinates)
  end

  def distance_from_business_to_s(coordinates)
    self.location.to_coordinates.present? ?
      self.distance_from_business(coordinates).round(1) : OUT_OF_RANGE
  end

  def messages_with_business(business)
    self.messages.where(sending_user_id: business.id).or(self.messages.where(receiving_user_id: business.id))
  end

  def shortlist_business(business)
    self.shortlists.create(business_id: business.id)
  end

  def remove_business
    #remove business and cancels project
    self.update_attributes(business_id: nil, project_status: :cancelled)
  end

  def generate_reference_number
    self.update_attributes(reference_number: "#{ [*'A'..'Z'].sample }#{ Date.today.strftime('%m') }#{ self.id }")
  end

  class << self

    def project_roles
      project_roles = Project.i18n_enum_collection(:contact_roles)

      project_roles["Other"] = project_roles.delete("Other")

      project_roles
    end

  end

end
