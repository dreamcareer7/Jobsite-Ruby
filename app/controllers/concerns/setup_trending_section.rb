module SetupTrendingSection
  extend ActiveSupport::Concern

  def setup_trending_section
    @new_businesses = Business.active.new_businesses.by_city(@current_city).distinct.limit(8).order(updated_at: :desc)
    @new_premium_businesses = Business.active.by_city(@current_city).new_premium_businesses.first(15).uniq{ |business| business.id }.sample(6)
    @new_projects = SelfAddedProject.new_projects.distinct.by_city(@current_city).sample(4)
  end

end
