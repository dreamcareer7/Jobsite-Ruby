class Quote < ApplicationRecord
  include EmailHelper

  validates :proposal, :approximate_duration, :project_id, :business_id, :approximate_budget, presence: true, on: :create

  belongs_to :business
  belongs_to :project

  has_many :attachments, as: :owner, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def submit_quote
    project = Project.find(self.project_id)
    business = self.business

    Notification.send_quote(self, project, business)
    send_new_quote_email(self)
  end

  def update_status(value)
    accept_quote if value == "accepted"

    self.update_attributes(status: value)
  end

  def accept_quote
    self.update_attributes(status: "accepted")
    self.project.add_business(self.business_id)
  end

end
