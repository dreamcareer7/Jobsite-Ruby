class Admin::BannersController < Admin::BaseController

  BANNER_TYPES = ["result banner", "side banner", "dashboard banner"]

  #after_action :verify_authorized

  def sidebar
    #authorize Banner

    respond_to do |format|
      format.html
      format.json { render json: SidebarBannerDatatable.new(view_context) }
    end

  end

  def dashboard
    #authorize Banner

    respond_to do |format|
      format.html
      format.json { render json: DashboardBannerDatatable.new(view_context) }
    end

  end

  def listing
    #authorize Banner

    respond_to do |format|
      format.html
      format.json { render json: ListingBannerDatatable.new(view_context) }
    end

  end

  def new
    authorize Banner

    @banner = Banner.new
    @banner_type = params[:banner_type].gsub("_", " ") if params[:banner_type].present?

    if session[:restore_params].present?
      params[:banner] = session[:restore_params]
      @banner.assign_attributes(banner_params)
      @banner_locations = session[:restore_params]["banner_locations"].reject(&:blank?)
      @banner_listings = session[:restore_params]["banner_listings"].reject(&:blank?)
      session.delete(:restore_params)
    end
    @banner_options = BANNER_TYPES
    @banner.banner_targets.build
  end

  def create
    authorize Banner

    @banner = Banner.create(banner_params)
    handle_listings_and_locations

    if @banner.save
      handle_redirect(@banner)
      flash[:notice] = "Banner created."
    else
      session[:restore_params] = banner_params
      handle_redirect(@banner)
      flash[:error] = @banner.errors.full_messages
    end
  end

  def edit
    @banner = Banner.find(params[:id])
    authorize @banner
    @banner_locations = @banner.locations.pluck(:id)
    @banner_listings = @banner.listings.pluck(:id)
    @banner_options = BANNER_TYPES
  end

  def update
    @banner = Banner.find(params[:id])
    authorize @banner

    #only build if the params are valid
    @banner.assign_attributes(banner_params)

    if @banner.valid?
      handle_listings_and_locations
    end

    if @banner.update_attributes(banner_params)
      handle_redirect(@banner)
      flash[:notice] = "Banner updated."
    else
      handle_redirect(@banner)
      flash[:error] = @banner.errors.full_messages
    end
  end

  def destroy
    @banner = Banner.find(params[:id])
    authorize @banner
    @banner.destroy
    redirect_back(fallback_location: sidebar_admin_banners_path)
    flash[:notice] = "Banner destroyed."
  end

  def handle_listings_and_locations
    countries = params[:banner][:banner_locations].reject(&:empty?).map(&:to_i)
    listings = params[:banner][:banner_listings].reject(&:empty?).map(&:to_i)

    cleanup_removed_attributes(countries, listings)

    countries.each do |country|
      target_country = Country.find(country)

      if listings.present?
        listings.each do |listing|
          target_listing = SubCategory.find(listing)
          next if @banner.banner_targets.where(target_location: target_country, target_listing: target_listing).present?

          @banner.banner_targets.build(target_location: target_country, target_listing: target_listing)
        end
      else
        next if @banner.banner_targets.where(target_location: target_country).present?

        @banner.banner_targets.build(target_location: target_country)
      end
    end
  end

  def cleanup_removed_attributes(countries, listings)
    removed_listings = @banner.banner_targets.where.not(target_listing: listings)
    removed_locations = @banner.banner_targets.where.not(target_location: countries)

    removed_listings.destroy_all
    removed_locations.destroy_all
  end

  def disable
    @banner = Banner.find(params[:banner_id])

    @banner.update(enabled: false)
    redirect_back(fallback_location: sidebar_admin_banners_path)
  end

  def enable
    @banner = Banner.find(params[:banner_id])

    @banner.update(enabled: true)
    redirect_back(fallback_location: sidebar_admin_banners_path)
  end

  def handle_redirect(banner)
    case banner.banner_type
    when "side banner"
      redirect_to sidebar_admin_banners_path
    when "result banner"
      redirect_to listing_admin_banners_path
    when "dashboard banner"
      redirect_to dashboard_admin_banners_path
    end
  end

  private

  def policy(record)
    Admin::BannerPolicy.new(current_admin, record)
  end

  def banner_params
    params.require(:banner).permit(
      :title,
      :banner_type,
      :image_en,
      :image_ar,
      :link_en,
      :link_ar,
      :start_date,
      :end_date,
      :enabled,
      :banner_listings => [],
      :banner_locations => [],
      :banner_targets_attributes =>  [ :id,
                                       :_destroy,
                                       :target_listing => [],
                                       :target_location => [] ])
  end

end
