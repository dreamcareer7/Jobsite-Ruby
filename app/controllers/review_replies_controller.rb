class Admin::ReviewRepliesController < ApplicationController
  after_action :verify_authorized

  def destroy
    @review_reply = ReviewReply.find(params[:id])
    authorize @@review_reply
    @review_reply.destroy
    redirect_back(fallback_location: admin_reviews_path)
  end

  protected

  def policy(record)
    Admin::ReviewReplyPolicy.new(current_admin, record)
  end

end
