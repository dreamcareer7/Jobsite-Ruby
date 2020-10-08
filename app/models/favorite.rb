class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoratable, polymorphic: true, counter_cache: :favoratable_count

  validates :user_id, uniqueness: {scope: [:favoratable_id, :favoratable_type]}
end
