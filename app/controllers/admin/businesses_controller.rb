class Admin::BusinessesController < Admin::BaseController
  include EmailHelper

  before_action :set_business, only: [:destroy, :delete_photo, :enable, :disable, :update, :edit, :dissociate_owner, :clear_business_hours]
  after_action :verify_authorized


  def index
    authorize Business

    respond_to do |format|
      format.html
      format.json { render json: BusinessDatatable.new(view_context) }
    end
  end

  def new
    authorize Business

    @resource = :admin

    @business = Business.new
    @business.build_business_contact
    2.times { @business.hours_of_operation.build }
  end

  def create
    authorize Business

    @business = current_admin.businesses.create(business_params)

    if @business.save
      redirect_to edit_admin_business_path(@business)
    else
      render :new
    end
  end

  def edit
    authorize @business

    @editor = 'admin'

    @categories = Category.includes(sub_categories: :services)

    @countries = Country.enabled.includes(:translations)
    @cities = City.enabled

    begin
      @admin_editor = Admin.find(@business.admin_editor) if @business.admin_editor.present?
    rescue ActiveRecord::RecordNotFound
      @admin_editor = "deleted"
    end

    resolve_notification

    @business.build_business_contact if @business.business_contact.blank?
    @business.team_members.build if @business.team_members.blank?
    @business.locations.build if @business.locations.blank?
    @business.build_brand if @business.brand.blank?

    if @business.hours_of_operation.blank?
      2.times { @business.hours_of_operation.build }
    elsif @business.hours_of_operation.count == 1
      @business.hours_of_operation.build
    end

  end

  def update
    authorize @business

    handle_disable(params[:business][:disabled]) if params[:business].has_key?(:disabled)

    if @business.update_attributes(business_params)
      @business.update_attributes(admin_editor: current_admin.id, admin_edit_date: Time.now)

      redirect_back(fallback_location: edit)
      flash[:notice] = "Business profile updated."
    else
      redirect_back(fallback_location: edit)
      flash[:error] = @business.errors.full_messages
    end
  end

  def handle_disable(disabled)
    # here we check to see if the disabled attribute has changed
    # if it has, and the business is now disabled, send an email notifying them
    #
    disabled = disabled == "0" ? false : true

    return unless disabled != @business.disabled

    return disable if disabled
  end

  def disable
    authorize @business

    @business.update(disabled: true)

    send_business_disabled_email(@business)

    #redirect_back(fallback_location: admin_businesses_path)

    flash[:error] = "Business disabled"
  end

  def enable
    authorize @business

    @business.update(disabled: false)
    redirect_back(fallback_location: admin_businesses_path)

    flash[:notice] = "Business enabled"
  end

  def delete_photo
    authorize @business

    case params[:photo_type]
    when "logo"
      @business.logo = nil
    when "banner"
      @business.banner = nil
    when "contact profile"
      @business.business_contact.profile_image = nil
    end

    @business.save
  end

  def dissociate_owner
    authorize @business

    @business.update(user: nil)
    redirect_back(fallback_location: edit_admin_business_path(@business))
  end

  def clear_business_hours
    authorize @business

    if params[:shift] == "all"
      @business.hours_of_operation.where(week_period: params[:week_period]).destroy_all
    else
      @business.hours_of_operation.where(week_period: params[:week_period]).first.update_attributes("#{ params[:shift] }_start": nil, "#{ params[:shift] }_end": nil )
    end

    redirect_back(fallback_location: admin_businesses_path)
    flash[:notice] = "Business profile updated."
  end

  def destroy
    authorize @business

    @business.destroy
    redirect_to admin_businesses_path
  end

  def resolve_notification
    unresolved_notification = AdminNotification.where(business: @business, resolved: false).first

    unresolved_notification.update(resolved: true) if unresolved_notification.present?
  end

  protected

  def set_business
    @business = Business.friendly.find(params[:id])
  end

  def policy(record)
    Admin::BusinessPolicy.new(current_admin, record)
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
      :business_type,
      :business_class,
      :project_size,
      :service_area,
      :approved,
      :flagged,
      :disabled,
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
      :id,
      :license_number,
      :banner,
      :logo,
      :user_id,
      :residential,
      :commercial,
      :government,
      :project_type_ids => [],
      :brand_attributes => [ :business_ids => [] ],
      :hours_of_operation_attributes => [  *HoursOfOperation.globalize_attribute_names,
                                           :week_period,
                                           :shift_one_start,
                                           :shift_one_end,
                                           :shift_two_start,
                                           :shift_two_end,
                                           :start_day,
                                           :end_day,
                                           :id ],
      :team_members_attributes =>  [ *TeamMember.globalize_attribute_names,
                                     :name,
                                     :role,
                                     :profile_image,
                                     :phone_number,
                                     :email,
                                     :id,
                                     :_destroy ],
      :locations_attributes =>  [ *Location.globalize_attribute_names,
                                  :number,
                                  :city_id,
                                  :street_address,
                                  :location_type,
                                  :description,
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
                                         :phone_number,
                                         :id ],
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
      :certification_ids => [],
      certifications_attributes: [ :id,
                                   :name,
                                   :logo],
      verification_ids: [],
      :verifications_attributes => [
        :id
      ],
      :users_attributes => [
        :id
      ]
    )
  end
end
