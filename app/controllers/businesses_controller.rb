class BusinessesController < ApplicationController
  include BusinessSummary
  include SortBusinesses
  include QuoteButtonHelper
  include Listing::Banners
  include Listing::Filter
  include Listing::Business
  include Business::Breadcrumbs

  skip_before_action :verify_authenticity_token, only: [:website_view, :social_view, :number_view, :project_view]

  before_action :set_businesses, only: [:index]
  before_action :set_categories, only: [:index]
  before_action :set_filter_terms, only: [:index]
  before_action :set_banners, only: [:index]

  after_action :record_listed_businesses, only: [:index]

  impressionist actions: [:index, :show, :website_view, :social_view, :number_view, :project_view]

  def new
    @business = Business.new

    @business.build_business_contact
    @business.locations.build

    @countries = Country.enabled.includes(:translations)
    @cities = City.enabled
  end

  def index
    @trending_sub_categories = @random_category.sub_categories.trending.first(3)

    @featured_businesses = get_featured_businesses(@unpaginated_businesses)
    @businesses = handle_filter(@unpaginated_businesses)
  end

  def show

    begin
      @business = Business.friendly.all.active.find(params[:id])
      return redirect_to business_path(id: @business.slug), :status => :moved_permanently if request.path != business_path(id: @business.slug)
    rescue ActiveRecord::RecordNotFound
      return redirect_back(fallback_location: root_path)
    end

    @markers = create_markers_for_locations
    setup_for_browsing_user


    #will only generate business summary if all attributes are present
    @summary = generate_summary(@business)

    @verifications = @business.verifications.includes(:translations)
    @sub_categories = @business.sub_categories.visible.enabled.distinct
    @services = @business.services.includes(:sub_category).visible.enabled.distinct
    @reviews = @business.reviews.includes(:user)

    @result_banners = Banner.relevant_banner("result banner", @current_city.country, @business.sub_categories).uniq
    @side_banner = Banner.relevant_banner("side banner", @current_city.country, @business.sub_categories)

    @similar_businesses = @business.similar_businesses(@current_city).limit(3).includes(:translations) unless @business.premium?

    @breadcrumbs = set_breadcrumbs

    impressionist(@business, "profile_view")
    session[:target_business] = @business.id
  end

  def create_markers_for_locations
    Gmaps4rails.build_markers(@business.locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow render_to_string(partial: "/partials/maps/info_window", locals: { location: location })
    end
  end

  def setup_for_browsing_user
    @projects = @current_user.projects.approved.includes(:translations).not_completed_or_accepted.where.not(project_status: :cancelled) if @current_user
    @favourite = @current_user.favourites.where(business_id: @business.id) if @current_user
    @user_callback = @current_user ? @business.user_callbacks.new : nil
    @message = @current_user ? @current_user.outgoing_messages.new : nil
    @email = ContactEmail.new
    @follow_count = @business.follows.count

    # click modal on login redirect
    if params[:target].present?
      @target_modal = params[:target]
    end

    # trigger section on navigation
    if params[:targetSection].present?
      @target_section = params[:targetSection]
    end
  end

  def flag_business
    @business = Business.friendly.find(params[:business_id])
    @business.update_attributes(flagged: true) unless @business.flagged?
    redirect_back(fallback_location: business_profile_index_path)
    flash[:error] = "Issue reported."
  end

  def website_view
    @business = Business.friendly.find(params[:business])
    impressionist(@business, "website_view")
  end

  def social_view
    @business = Business.friendly.find(params[:business])
    impressionist(@business, "social_view")
  end

  def number_view
    @business = Business.friendly.find(params[:business])
    impressionist(@business, "number_view")
  end

  def project_view
    @business = Business.friendly.find(params[:business])
    impressionist(@business, "project_view")
  end


  private

  def set_businesses
    @unpaginated_businesses = Business.active.for_listing.by_city(@current_city)
  end

  def set_categories
    @categories = Category.all
    @random_category = @categories.shuffle.first
  end

  def set_banners
    banners(@random_category)
  end

  def record_listed_businesses
    RecordListedBusinessesJob.perform_later(@businesses)
  end

end
