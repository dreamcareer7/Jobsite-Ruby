class Admin::ReviewsController < Admin::BaseController
  before_action :set_review, only: [:destroy, :show]
  after_action :verify_authorized

  def index
    authorize Review

    respond_to do |format|
      format.html
      format.json { render json: ReviewDatatable.new( view_context ) }
    end
  end

  def show
    authorize @review
  end

  def destroy
    authorize @review

    @review.destroy
    redirect_to admin_reviews_path
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def policy(record)
    Admin::ReviewPolicy.new(current_admin, record)
  end

end