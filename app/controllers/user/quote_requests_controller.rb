class User::QuoteRequestsController < User::BaseController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  include EmailHelper

  def create
    authorize QuoteRequest.new
    @quote_request = QuoteRequest.create(quote_request_params)

    if @quote_request.save
      redirect_back(fallback_location: root_path)
      flash[:notice] = "Your quote request has been submitted."
      Notification.send_quote_request(@quote_request)
      send_invited_to_project_email(@quote_request.project, @quote_request.business)
    else
      redirect_back(fallback_location: root_path)
      if @quote_request.errors.full_messages.first.include? "taken"
        flash[:error] = "You have already submittted a quote request for this project to this business."
      else
        flash[:error] = "There was an error submitting your quote request."
      end
    end
  end

  def decline_quote_request
    QuoteRequest.find(params[:id]).update_columns(status: "declined")
  end

  private

  def user_not_authorised
    redirect_to(request.referrer || default_path)
    flash[:error] = "Sorry, you must be a pro user to request more than two quotes a month."
  end

  def quote_request_params
    params.require(:quote_request).permit(:business_id, :user_id, :project_id)
  end

end
