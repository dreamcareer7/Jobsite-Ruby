class Business::ReviewRepliesController < Business::BaseController

  def new
    @review_reply = ReviewReply.new
    @review = Review.find(params[:review])
    @project = @review.project

    session[:review_id] = params[:review]
  end

  def edit
    @review_reply = ReviewReply.find(params[:id])
    @review = @review_reply.review
    @project = @review_reply.project
  end

  def create
    params[:review_reply][:review_id] = session[:review_id]
    params[:review_reply][:business_id] = current_business.id
    @review_reply = ReviewReply.create(review_reply_params)

    session.delete(:review)

    if @review_reply.save
      redirect_to business_reviews_path
      flash[:notice] = "Reply submitted."
      session.delete(:project_id)
    else
      redirect_back(fallback_location: business_profile_index_path)
      flash[:error] = @review_reply.errors.full_messages
    end
  end

  def update
    @review_reply = ReviewReply.find(params[:id])

    if @review_reply.update_attributes(review_reply_params)
      redirect_to business_reviews_path
      flash[:notice] = "Reply updated."
    else
      redirect_back(fallback_location: business_profile_index_path)
      flash[:error] = @review_reply.errors.full_messages
    end
  end


  private

  def review_reply_params
    params.require(:review_reply).permit(:business_id, :review_id, :body)
  end

end
