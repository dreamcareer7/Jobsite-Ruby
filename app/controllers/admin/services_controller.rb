class Admin::ServicesController < Admin::BaseController
  before_action :set_service, only: [:destroy, :update, :edit, :enable, :disable]

  def index
    respond_to do |format|
      format.html do
        @subcategory = SubCategory.find(params[:sub_category_id]) if params[:sub_category_id]
      end
      format.json { render json: ServiceDatatable.new(view_context) }
    end
  end

  def show
    redirect_to admin_categories_path
  end

  def new
    @service = Service.new
    @sub_category = SubCategory.find(params[:sub_category_id])
    @service.build_category_metadata if @service.category_metadata.blank?
  end

  def create
    @service = Service.create(service_params)
    redirect_to admin_services_path(sub_category_id: @service.sub_category.id)
  end

  def edit
    @sub_category = @service.sub_category
    @service.build_category_metadata if @service.category_metadata.blank?
    params[:sub_category_id] = @service.sub_category_id
  end

  def update
    @sub_category = @service.sub_category
    @service.build_category_metadata if @service.category_metadata.blank?
    if @service.update_attributes( service_params )
      redirect_to admin_services_path( sub_category_id: @service.sub_category.id )
    else
      render 'edit'
    end
  end

  def destroy
    sub_category_id = @service.sub_category_id
    @service.destroy
    redirect_to admin_services_path(sub_category_id: sub_category_id)
  end

  def disable
    @service.update(disabled: true)
    redirect_back(fallback_location: admin_cities_path)
  end

  def enable
    @service.update(disabled: false)
    redirect_back(fallback_location: admin_cities_path)
  end

  protected

  def set_service
    @service = Service.friendly.find(params[:id])
  end

  def service_params
    params.require(:service).permit(
      :name_en,
      :name_ar,
      :sub_category_id,
      :category_metadata_attributes =>[
        :subheadline_en,
        :subheadline_ar,
        :description_en,
        :description_ar,
        :banner
      ]
    )
  end

end
