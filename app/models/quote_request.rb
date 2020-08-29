class QuoteRequest < ApplicationRecord

  validates :user, :business, :project, :status, presence: true
  validates_uniqueness_of :business_id, scope: :project_id

  belongs_to :user
  belongs_to :project
  belongs_to :business

  class << self

    def by_status(status)
      QuoteRequest.where(status: status)
    end

  end

end
