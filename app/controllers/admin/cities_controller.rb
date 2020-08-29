class Admin::CitiesController < Admin::BaseController
  before_action :set_city, only: [:destroy, :update, :edit, :enable, :disable]
  after_action :verify_authorized

  def index
    authorize City

    respond_to do |format|
      format.html do
        @country = Country.find(params[:country_id]) if params[:country_id]
      end
      format.json { render json: CityDatatable.new(view_context ) }
    end
  end

  def show
    authorize City
    redirect_to admin_cities_path
  end

  def new
    authorize City
    @city = City.new
    @city.city_banners.build
  end

  def create
    authorize City
    @city = City.create(city_params)
    redirect_to admin_cities_path(country_id: @city.country_id)
  end

  def edit
    authorize @city
    @city.city_banners.build if @city.city_banners.blank?

    params[:country_id] = @city.country_id
  end

  def update
    authorize @city

    if @city.update_attributes(city_params)
      redirect_back(fallback_location: admin_cities_path)
    else
      redirect_back(fallback_location: admin_cities_path)
    end
  end

  def destroy
    authorize @city
    country_id = @city.country_id
    @city.destroy
    redirect_to admin_cities_path(country_id: country_id)
  end

  def disable
    authorize @city

    @city.update(disabled: true)
    redirect_back(fallback_location: admin_cities_path)
  end

  def enable
    authorize @city

    @city.update(disabled: false)
    redirect_back(fallback_location: admin_cities_path)
  end

  protected

  def set_city
    @city = City.friendly.find(params[:id])
  end

  def policy(record)
    Admin::CityPolicy.new(current_admin, record)
  end

  def city_params
    params.require(:city).permit(
      :name_en,
      :name_ar,
      :country_id,
      :longitude,
      :latitude,
      :city_banners_attributes => [ :image,
                                    :description_en,
                                    :description_ar,
                                    :link,
                                    :_destroy,
                                    :id ]
    )
  end

end
