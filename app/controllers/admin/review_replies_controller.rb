class Admin::ReviewRepliesController < ApplicationController

  def destroy
    ReviewReply.find(params[:id]).destroy
    redirect_back(fallback_location: admin_reviews_path)
  end

end
