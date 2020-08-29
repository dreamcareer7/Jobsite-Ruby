module BusinessSummary
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper

  def generate_summary(business)

    #will only generate business summary if all attributes are present
    [:services, :locations, :countries, :business_class, :cities, :master_category, :service_area, :business_type, :project_size, :years_of_establishment].each do |target_method| 
      return false unless business.try(target_method).present?
    end

    @summary_type = t("business_summary.#{ business.master_category.name.singularize.downcase}", setup_variables(business))
  end

  def setup_variables(business)
    @branch_count = "#{ pluralize(business.locations.distinct.count, t("words.branch")) }"
    @city_count = "#{ pluralize(business.cities.distinct.count, t("words.city")) }"
    @city_branch_count = business.cities.distinct.length > 1 ? " #{ t("words.with").downcase } #{ @branch_count } #{ t("words.in").downcase } #{ @city_count } " : ""
    @services = business.services.visible.present? ? business.services.visible.limit(3).map{ |service| service.name.downcase }.to_sentence : business.categories.distinct.first(2).map{ |category| category.name.downcase }.to_sentence
    {
      master_category: business.master_category.name.downcase.singularize,
      services: @services,
      city: business.locations.order(:created_at).first.city.name,
      country: business.countries.first.name,
      city_branch_count: @city_branch_count,
      project_size: business.project_size.downcase,
      service_area: business.service_area.downcase,
      business_type: business.business_type.downcase,
      year_established: business.years_of_establishment,
      business_class: business.business_class
    }
  end

end
