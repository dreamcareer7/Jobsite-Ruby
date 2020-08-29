class Admin::CertificationsController < Admin::BaseController
  after_action :verify_authorized

  def index
    authorize Certification

    respond_to do |format|
      format.html
      format.json { render json: CertificationDatatable.new(view_context) }
    end
  end

  def show
    authorize Certification
    redirect_to admin_certifications_path
  end

  def new
    authorize Certification
  	@certification = Certification.new
  end

  def create
    authorize Certification
    @certification = Certification.create(certification_params)
    redirect_to admin_certifications_path
  end

  def edit
    @certification = Certification.find(params[:id])
    authorize @certification
  end

  def update
    @certification = Certification.find(params[:id])
    authorize @certification
    if @certification.update_attributes(certification_params)
      redirect_to admin_certifications_path
    else
      render 'edit'
    end
  end

  def destroy
    @certification = Certification.find(params[:id])
    authorize @certification
    @certification.destroy
    redirect_back(fallback_location: admin_certifications_path)
  end

  protected

  def policy(record)
    Admin::CertificationPolicy.new(current_admin, record)
  end

  def certification_params
    params.require(:certification).permit(
      :name,
      :name_en,
      :name_ar,
      :logo,
      :country_id
    )
  end

end
