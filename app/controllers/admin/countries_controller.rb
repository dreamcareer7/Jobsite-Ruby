class Admin::CountriesController < Admin::BaseController
  before_action :set_country, only: [:destroy, :update, :edit, :enable, :disable]
  after_action :verify_authorized

  def index
    authorize Country

    respond_to do |format|
      format.html
      format.json { render json: CountryDatatable.new(view_context) }
    end
  end

  def show
    authorize @country
    redirect_to admin_countries_path
  end

  def new
    authorize Country
    @country = Country.new
  end

  def create
    authorize Country
    @country = Country.create(country_params)
    redirect_to admin_countries_path
  end

  def edit
    authorize @country
  end

  def update
    authorize @country

    if @country.update_attributes(country_params)
      redirect_to admin_countries_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @country

    cities = City.where(country_id: @country.id).destroy_all
    @country.destroy
    redirect_back(fallback_location: admin_countries_path)
  end

  def disable
    authorize @country

    @country.update(disabled: true)
    redirect_back(fallback_location: admin_countries_path)
  end

  def enable
    authorize @country

    @country.update(disabled: false)
    redirect_back(fallback_location: admin_countries_path)
  end

  protected

  def set_country
    @country = Country.find(params[:id])
  end

  def policy(record)
    Admin::CountryPolicy.new(current_admin, record)
  end

  def country_params
    params.require(:country).permit(
      :name,
      :name_en,
      :name_ar,
      :continent,
      :longitude,
      :latitude
    )
  end

end
