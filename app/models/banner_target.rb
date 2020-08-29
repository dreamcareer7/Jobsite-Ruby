class BannerTarget < ApplicationRecord
  belongs_to :banner
  belongs_to :target_listing, polymorphic: true
  belongs_to :target_location, class_name: "Country"

  validates :target_listing, presence: true, unless: :dashboard_banner?
  validates :target_location, presence: true

  def dashboard_banner?
    return if self.banner.nil?

    self.banner.banner_type == "dashboard banner"
  end

end
