class Notification < ApplicationRecord
  include TimeHelper

  validates :sending_user_id, :sending_user_type, :receiving_user_id, :receiving_user_type, presence: true

  belongs_to :project

  scope :by_type, -> (type) { where(notification_type: type) }

  def mark_as_read
    self.update_attributes(read: true) unless self.read
  end

  def sender
    self.sending_user_type.constantize.find(self.sending_user_id)
  end

  def receiver
    self.receiving_user_type.constantize.find(self.receiving_user_id)
  end


  def is_sender?(user, business)

    return self.sender.id == business.id && self.sender.class == business.class if user.blank?
    return self.sender.id == user.id && self.sender.class == user.class if business.blank?

    self.sender.id == user.id && self.sender.class == user.class ||
    self.sender.id == business.id && self.sender.class == business.class
  end

  class << self
    include HandleNotifications

    def by_type(type)
      return Notification.all unless type.present?
      Notification.where(notification_type: type)
    end
  end

end
