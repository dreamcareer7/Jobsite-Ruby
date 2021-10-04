class User::ReviewsController < User::BaseController

  def index
    @reviews = Kaminari.paginate_array(current_user.reviews.order(created_at: :desc)).page(params[:page]).per(6)
  end

  def new
    @project = Project.find(params[:project_id])
    authorize @project
    @review = Review.new
    @business = @project.business

    session[:business_id] = @business.id
    session[:project_id] = @project.id
  end

  def create
    params[:review][:business_id] = session[:business_id]
    params[:review][:project_id] = session[:project_id]

    @review = current_user.reviews.create(review_params)

    if @review.save
      Notification.send_review(@review, @review.project, @review.business)
      redirect_to user_reviews_path
      session.delete(:business_id)
      session.delete(:project_id)
    else
      redirect_back(fallback_location: user_profile_index_path)
      flash[:error] = "The review could not be submitted at this time."
    end
  end

  def update
    @review = Review.find_by_id(params[:id])
    @review_id = @review.id
    if @review.update!(review_params)
      redirect_back(fallback_location:  user_reviews_path)
      flash[:notice] = "your review has been updated."
    else
      redirect_back(fallback_location:  user_reviews_path)
      flash[:error] = "review has problem to update"
    end
  end

  private

  def review_params
    params.require(:review).permit(:id, :reliability, :tidiness, :courtesy, :workmanship, :value_for_money, :comment, :recommended, :user_id, :business_id, :project_id)
  end

end
