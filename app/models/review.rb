class Review < ApplicationRecord
  include ReviewsHelper
  include EmailHelper

  validates :reliability, :tidiness, :courtesy, :workmanship, :value_for_money, :user_id, :business_id, :project_id, presence: true
  validates :reliability, :tidiness, :courtesy, :workmanship, :value_for_money, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates_inclusion_of :recommended, in: [true, false]
  validates :project_id, uniqueness: true

  has_one :review_reply, dependent: :destroy

  belongs_to :user
  belongs_to :business, counter_cache: true
  belongs_to :project

  scope :new_reviews, -> { includes(:user, :business).order(created_at: :desc) }
  scope :by_city, -> (city) { joins(:project).merge(Project.by_city(city)) }

  after_create :new_review_email


  def average_score
    review_categories = [self.reliability, self.tidiness, self.courtesy, self.workmanship, self.value_for_money]
    review_sum = review_categories.reduce(:+).to_f

    return review_sum / review_categories.count
  end

  private

  def new_review_email
    send_new_review_email
  end

end
