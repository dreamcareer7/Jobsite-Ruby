class Subscription < ApplicationRecord

  validates :subscription_type, presence: true

  belongs_to :user
  belongs_to :business

  after_create :generate_reference_number

  enum subscription_type: [
    'free',
    'pro',
    'standard',
    'premium'
  ]

  scope :valid, -> { where("expiry_date >= ?", Date.today) }
  scope :new_premium, -> { where(subscription_type: "premium").order(created_at: :desc).includes(user: :businesses) }

  private

  def generate_reference_number
    self.update_attributes(reference_number: "#{ self.business.present? ? self.business.name[0] : self.user.name[0] }#{ Date.today.strftime('%m') }#{ self.id }")
  end

end
