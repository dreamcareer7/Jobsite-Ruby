class AdminNotification < ApplicationRecord
  belongs_to :user
  belongs_to :business
  belongs_to :project

  enum notification_type: [
    :user_upgrade,
    :business_upgrade,
    :business_claim,
    :problem_report,
    :new_business,
    :new_project,
    :new_review,
    :new_callback_request,
    :job,
    :business,
    :advertise,
    :general,
    :other,
    :claim
  ]

  scope :by_type, -> (notification_type) { where(notification_type: notification_type) }
  scope :business_claims, -> { where(notification_type: [:business_claim, :claim]) }
  scope :upgrade_requests, -> { where(notification_type: [:user_upgrade, :business_upgrade]) }
  scope :inquiries, -> { where(notification_type: [:job, :general, :other, :business]) }
  scope :site_notifications, -> { where(notification_type: :problem_report) }
  scope :unresolved, -> { where(resolved: false) }

  def humanise_type
    self.notification_type.gsub("_", " ").capitalize
  end

  def sender
    self.user.present? ? self.user : self.business
  end

  def self.new_project_notification(project)
    AdminNotification.create(notification_type: :new_project, user: project.user, project: project)
  end

  def self.new_business_notification(business)
    AdminNotification.create(notification_type: :new_business, user: business.user, business: business)
  end

  def self.new_review_notification(project)
    AdminNotification.create(notification_type: :new_review, user: project.user, business: project.business, project: project)
  end

  def self.new_callback_request_notification(user, business)
    AdminNotification.create(notification_type: :new_callback_request, user: user, business: business)
  end

  def self.business_claim(user, business)
    AdminNotification.create(notification_type: :notify_business_claim, user: user, business: business)
  end

  def self.inquiry_notification(details)
    AdminNotification.create(
      notification_type: details.subject_target, 
      content: details.body,
      user_number: details.number,
      user_email: details.from
    )
  end

end
