class Business::QuotesController < Business::BaseController
  require 'zip'
  require 'rubygems'
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised


  def index
    @quotes = Business.find(params[:id]).quotes
  end

  def new
    @quote = Quote.new
    @quote.attachments.build

    @project = Project.find(params[:project_id])
    session[:project_id] = @project.id
    # authorize @quote
  end

  def create
    params[:quote][:project_id] = session[:project_id]
    params[:quote][:business_id] = current_business.id
    @quote = Quote.create(quote_params)

    if @quote.save
      @quote.submit_quote
      @project = Project.find(session[:project_id])

      params[:message] = {}
      params[:message][:project_id] = @project.id
      params[:message][:receiving_user_id] = @project.user_id
      params[:message][:receiving_user_type] = "User"
      params[:message][:body] = "Proposal: #{@quote.proposal} \n Budget: #{@quote.approximate_budget} \n Duration: #{@quote.approximate_duration}" 

      new_message = current_business.outgoing_messages.create(message_params)

      redirect_to business_project_feed_index_path
      flash[:notice] = "Quote submitted."
      session.delete(:project_id)
    else
      redirect_back(fallback_location: business_profile_index_path)
      flash[:error] = @quote.errors.full_messages
    end
  end

  def update_quote_status
    quote = Quote.find(params[:quote_id])

    quote.update_status(params[:status])
    redirect_back(fallback_location: user_profile_index_path)
    flash[:notice] = "Quote status updated."
  end

  def download_as_zip
    #http://thinkingeek.com/2013/11/15/create-temporary-zip-file-send-response-rails/

    @quote = Quote.find(params[:quote_id])
    
    file_name = "attachments - #{ @quote.business.name }.zip"
    temp_file = Tempfile.new(file_name)

    begin
      Zip::OutputStream.open(temp_file) { |zos| }

      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        @quote.attachments.each do |attachment|
          zip.add(attachment.attachment_file_name, Rails.root.join(attachment.attachment.path))
        end
      end

      zip_data = File.read(temp_file.path)

      send_data(zip_data, :type => 'application/zip', :filename => file_name)
    ensure
      temp_file.close
      temp_file.unlink
    end

  end

  private

  def pundit_user
    @current_business
  end

  def user_not_authorised
    redirect_to(request.referrer || default_path)
    flash[:error] = "Sorry, you must upgrade to a standard or premium account to send quotes."
  end

  def quote_params
    params.require(:quote).permit(
      :introduction,
      :proposal,
      :reference_number,
      :valid_until,
      :approximate_duration,
      :approximate_budget,
      :business_id,
      :project_id,
      :status,
      :attachments_attributes => [ :id, :attachment, :_destroy ])
  end

  def message_params
    params.require(:message).permit(:body, :receiving_user_id, :receiving_user_type, :project_id, :conversation_id, :attachment_attributes => [ :id, :attachment, :_destroy ])
  end

end
