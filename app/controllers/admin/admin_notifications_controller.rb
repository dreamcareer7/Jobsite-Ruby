class Admin::AdminNotificationsController < Admin::BaseController

  def site
    respond_to do |format|
      format.html
      format.json { render json: SiteDatatable.new(view_context) }
    end
  end

  def business_claim
    respond_to do |format|
      format.html
      format.json { render json: BusinessClaimDatatable.new(view_context) }
    end
  end

  def inquiries
    respond_to do |format|
      format.html
      format.json { render json: InquiryDatatable.new(view_context) }
    end
  end

  def upgrade
    respond_to do |format|
      format.html
      format.json { render json: UpgradeDatatable.new(view_context) }
    end
  end

  def new_businesses
    respond_to do |format|
      format.html
      format.json { render json: NewBusinessDatatable.new(view_context) }
    end
  end

  def new_projects
    respond_to do |format|
      format.html
      format.json { render json: NewProjectDatatable.new(view_context) }
    end
  end

  def new_reviews
    respond_to do |format|
      format.html
      format.json { render json: NewReviewDatatable.new(view_context) }
    end
  end

  def new_callback_requests
    respond_to do |format|
      format.html
      format.json { render json: NewCallbackRequestDatatable.new(view_context) }
    end
  end

  def create

    @notification = AdminNotification.create(admin_notification_params)

    if @notification.save
      redirect_back(fallback_location: root_path)
      flash[:notice] = "Request sent"
    else
      redirect_back(fallback_location: root_path)
      flash[:error] = @notification.errors.full_messages
    end

  end

  def show
    @notification = AdminNotification.find(params[:id])
  end

  def update
    @notification = AdminNotification.find(params[:id])

    if @notification.update_attributes(admin_notification_params)
      redirect_back(fallback_location: user_admin_admin_notifications_path)
      flash[:notice] = "Request updated"
    else
      redirect_back(fallback_location: user_admin_admin_notifications_path)
      flash[:error] = @notification.errors.full_messages
    end
      
  end

  def toggle_resolve
    @notification = AdminNotification.find(params[:id])
    if @notification.resolved?
      @notification.update(resolved: false)
      flash[:notice] = "Resolved"
    else
      @notification.update(resolved: true)
      flash[:notice] = "Unresolved"
    end

    redirect_back(fallback_location: site_admin_admin_notifications_path)
  end

  private

  def admin_notification_params
    params.require(:admin_notification).permit(:notification_type, :content, :page_link, :user_id, :business_id, :resolved, :user_number, :project)
  end

end
