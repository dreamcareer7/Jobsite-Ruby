class User::BusinessesController < User::BaseController
  include EmailHelper

  def index
    @businesses = current_user.businesses
  end

  def new
    @business = Business.new
    @business.build_business_contact
    @business.locations.build
    @countries = Country.enabled.includes(:translations)
    @cities = City.enabled
  end

  def show
    @business = Business.friendly.find(params[:id])
    authorize @business
  end

  def create
    @business = current_user.businesses.create(business_params)

    if @business.save
      session[:business_id] = @business.id
      redirect_to business_profile_index_path
    else
      render :new
    end
  end

  def edit
    @business = Business.friendly.find(params[:id])
    authorize @business
    @category_list = @business.category_list
    @countries = Country.enabled.includes(:translations)
    @cities = City.enabled
  end

  def update
    @business = Business.friendly.find(params[:id])

    authorize @business

    if @business.update_attributes(business_params)
      if params[:business][:name_en].present? || params[:business][:name_ar].present?
        redirect_to business_profile_index_path
      else
        redirect_back(fallback_location: business_profile_index_path)
      end
      flash[:notice] = "Business profile updated."
    else
      redirect_back(fallback_location: business_profile_index_path)
      flash[:error] = @business.errors.full_messages
    end
  end

  def destroy
    @business = Business.find(params[:id])
    authorize @business

    if session[:business_id].present? && session[:business_id] == params[:id].to_i
      session.delete(:business_id)
    end
    @business.destroy
    redirect_to user_businesses_path
  end

  def claim_business
    if current_user.blank?
      redirect_to new_user_registration_path
    end
    Notification.send_business_claim(current_user, params[:business_id].to_i)
  end


  private

  def user_not_authorised
    redirect_back(fallback_location: user_profile_index_path)
  end

  def business_params
    params.require(:business).permit(
      *Business.globalize_attribute_names,
      :name,
      :name_en,
      :name_ar,
      :description,
      :business_hours,
      :min_budget,
      :max_budget,
      :nb_projects_completed,
      :po_box,
      :telephone,
      :fax,
      :email,
      :website,
      :number_of_employees,
      :years_of_establishment,
      :number_of_branches,
      :insurance_coverage,
      :legal_status,
      :license_number,
      :id,
      :banner,
      :logo,
      :certification_ids => [],
      :project_type_ids => [],
      :hours_of_operation_attributes => [ *HoursOfOperation.globalize_attribute_names,
                                           :start_day,
                                           :end_day,
                                           :start_time,
                                           :end_time ],
      :team_members_attributes =>  [ *TeamMember.globalize_attribute_names,
                                     :name,
                                     :role,
                                     :profile_image,
                                     :email,
                                     :phone_number,
                                     :id,
                                     :_destroy ],
      :locations_attributes =>  [ *Location.globalize_attribute_names,
                                  :name,
                                  :number,
                                  :city_id,
                                  :description,
                                  :location_type,
                                  :street_address,
                                  :latitude,
                                  :longitude,
                                  :zip,
                                  :po_box,
                                  :id,
                                  :_destroy ],
      :social_links_attributes => [ :facebook,
                                    :twitter,
                                    :instagram,
                                    :youtube,
                                    :google_plus,
                                    :linkedin,
                                    :prequalification,
                                    :id ],
      :business_contact_attributes =>  [ *BusinessContact.globalize_attribute_names,
                                         :name,
                                         :email,
                                         :position,
                                         :profile_image,
                                         :phone_number ],
      :self_added_projects_attributes => [ *SelfAddedProject.globalize_attribute_names,
                                           :title,
                                           :description,
                                           :video_link,
                                           :image_one,
                                           :image_two,
                                           :image_three,
                                           :id,
                                           :_destroy ],
      service: {},
      services: [],
      service_ids: [],
      services_attributes: [ :id,
                             :name,
                             :sub_category_id],
      certifications_attributes: [ :id,
                                   :name,
                                   :logo])
  end

end
