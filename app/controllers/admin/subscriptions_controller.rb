class Admin::SubscriptionsController < Admin::BaseController
  before_action :set_subscription, only: [:edit, :update, :destroy]

  def new
    @subscription = Subscription.new

    if params[:user_id].present?
      @target = User.find(params[:user_id])
    elsif params[:business_id].present?
      @target = Business.friendly.find(params[:business_id])
    else
      redirect_back(fallback_location: admin_businesses_path)
    end

    @user_type = params[:user_type]
  end

  def create
    @subscription = Subscription.create(subscription_params)

    @target = subscription_target

    if @subscription.save
      flash[:notice] = "Subscription created"
      send_invoice

      #redirect to vendor or user depending on type
      if @target.is_a?(Business)
        @target.business_upgraded(@subscription)
        redirect_to edit_admin_business_path(@target)
      else
        @target.user_upgraded(@subscription)
        redirect_to edit_admin_user_path(@target)
      end

    else
      flash[:error] = @subscription.errors.full_messages
      render :new
    end
  end

  def edit
    @target = subscription_target
  end

  def update
    @target = subscription_target

    if @subscription.update_attributes(subscription_params)
      flash[:notice] = "Subscription updated"

      #redirect to business or user depending on type
      if @target.is_a?(Business)
        redirect_to edit_admin_business_path(@target)
      else
        redirect_to edit_admin_user_path(@target)
      end

    else
      flash[:error] = @subscription.errors.full_messages
      render :edit
    end
  end

  def destroy
    @target = subscription_target
    @subscription.destroy
    flash[:notice] = "Subscription deleted"

    if @target.is_a?(User)
      redirect_back(fallback_location: edit_admin_user_path(@target.id))
    else
      redirect_back(fallback_location: edit_admin_business_path(@target.id))
    end
  end

  def send_invoice
    @subscription ||= Subscription.find(params[:subscription_id])
    @target = subscription_target
    @contact_email = subscription_email
    @contact_address = subscription_address

    return if @subscription.subscription_type == "free" || @contact_email.blank?

    email = SubscriptionMailer.send_invoice(@subscription, @target, @contact_email, @contact_address).deliver_now

    unless email.errors.present?
      flash[:notice] = "Invoice sent"
    else
      flash[:error] = email.errors
    end

  end

  def send_receipt
    @subscription = Subscription.find(params[:subscription_id])
    @target = subscription_target
    @contact_email = subscription_email
    @contact_address = subscription_address

    return if @subscription.subscription_type == "free" || @contact_email.blank?

    email = SubscriptionMailer.send_receipt(@subscription, @target, @contact_email, @contact_address).deliver_now

    unless email.errors.present?
      flash[:notice] = "Receipt sent"

      respond_to { |format| format.js }

    else
      flash[:error] = email.errors
    end

  end

  protected

  def subscription_target
    #create subscription for user or business
    if @subscription.business.present?
      @subscription.business
    elsif @subscription.user.present?
      @subscription.user
    else
      redirect_back(fallback_location: admin_businesses_path)
    end
  end

  def subscription_email

    if @target.is_a?(User)
      return @target.email
    elsif @target.is_a?(Business) && @target.email.present?
      return @target.email
    elsif @target.is_a?(Business) && @target.user.present?
      return @target.user.email
    end

  end

  def subscription_address

    if @target.is_a?(User) && @target.location.present? && @target.location.street_address.present?
      return @target.location.street_address
    elsif @target.is_a?(Business) && @target.locations.present? && @target.locations.first.street_address.present?
      return @target.locations.first.street_address
    else
      return "Information not provided"
    end

  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:user_id, :business_id, :subscription_type, :payment_method, :expiry_date, :auto_renew, :amount_paid)
  end

end
