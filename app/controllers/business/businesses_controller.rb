class Business::BusinessesController < Business::BaseController
  def edit
    @business = Business.friendly.find(params[:id])
    @business.build_business_contact if @business.business_contact.blank?
    @section = "general_information"
    @sub_categories_chosen = @business.sub_categories
    authorize @business
    build_associations
  end

  def switch_form_section
    @business = Business.friendly.find(params[:business_id])
    @section = params[:section]

    session[:section] = params[:section]


    if @section == 'locations'
      @countries = Country.enabled.includes(:translations)
      @cities = City.enabled
    end

    if @section == "services"
      @categories = Category.includes(sub_categories: :services)
    end

    build_associations

    respond_to do |format|
      format.js
    end
  end

  def build_associations
    @business.build_business_contact if @business.business_contact.blank?
    @business.hours_of_operation.build if @business.hours_of_operation.blank?
    @business.team_members.build if @business.team_members.blank?
    @business.locations.build if @business.locations.blank?
  end

end
