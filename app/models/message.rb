class Message < ApplicationRecord
  include TimeHelper
  validates :sending_user_id, :sending_user_type, :receiving_user_id, :receiving_user_type, presence: true
  
  belongs_to :sender
  belongs_to :receiver
  belongs_to :project
  has_one :attachment, as: :owner, dependent: :destroy

  belongs_to :conversation

  validates :body, presence: true, unless: :some_validation_check

  def some_validation_check
    attachment.present?
  end

  accepts_nested_attributes_for :attachment, reject_if: :all_blank, allow_destroy: true

  def mark_as_read
    self.update_attributes(read: true) unless self.read
  end

  def business
    return Business.find(self.sending_user_id) if self.sending_user_type == "Business"
    return Business.find(self.receiving_user_id) if self.receiving_user_type == "Business"
    return nil
  end

  def user
    return User.find(self.sending_user_id) if self.sending_user_type == "User"
    return User.find(self.receiving_user_id) if self.receiving_user_type == "User"
    return nil
  end

  def sender
    begin
    self.sending_user_type.constantize.find(self.sending_user_id)
    rescue ActiveRecord::RecordNotFound
      self.receiver
    end
  end

  def receiver
    begin
      self.receiving_user_type.constantize.find(self.receiving_user_id)
    rescue ActiveRecord::RecordNotFound
      ""
    end
  end

  def is_sender?(user, business)

    return self.sender.id == business.id && self.sender.class == business.class if user.blank?
    return self.sender.id == user.id && self.sender.class == user.class if business.blank?

    self.sender.id == user.id && self.sender.class == user.class ||
    self.sender.id == business.id && self.sender.class == business.class
  end

  def project
    self.project_id.present? ? Project.find(self.project_id) : ""
  end

end
