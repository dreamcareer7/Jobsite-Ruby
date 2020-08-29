class Admin::VerificationsController < Admin::BaseController
  before_action :set_verification, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize Verification

    respond_to do |format|
      format.html
      format.json { render json: VerificationDatatable.new(view_context) }
    end
  end

  def show
    authorize @verification
    redirect_to admin_verifications_path
  end

  def new
    authorize Verification
    @verification = Verification.new
  end

  def edit
    authorize @verification
  end

  def create
    authorize Verification

    @verification = Verification.create(verification_params)
    redirect_to admin_verifications_path
  end

  def update
    authorize @verification

    if @verification.update_attributes(verification_params)
      redirect_to admin_verifications_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @verification

    @verification.destroy
    redirect_back(fallback_location: admin_verifications_path)
  end

  protected

  def set_verification
    @verification = Verification.find(params[:id])
  end

  def policy(record)
    Admin::VerificationPolicy.new(current_admin, record)
  end

  def verification_params
    params.require(:verification).permit(
      :name,
      :name_en,
      :name_ar
    )
  end

end