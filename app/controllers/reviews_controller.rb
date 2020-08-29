class ReviewsController < ApplicationController

  def index
    @business = Business.friendly.find(params[:business_id])
    @reviews = @business.reviews
  end

end
