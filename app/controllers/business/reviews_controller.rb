class Business::ReviewsController < Business::BaseController

  def index
    @reviews = current_business.reviews
  end

  def show
    @review = Review.find(params[:id])
  end

end

