class ProjectFeedController < ApplicationController
  include SortProjectFeed

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  after_action :verify_policy_scoped, only: [:index?, :show?]

  def index
    authorize Project
    get_projects

    @filter_terms = ["All projects", "Invited only"]

    if params[:filter_by].present?
      @projects = handle_sorting(@projects, params[:filter_by])
    else
      params[:filter_by] = "Dateadded"
      @projects = handle_sorting(@projects, params[:filter_by])
    end
    @project_feed = @projects.paginate(page: params[:page], per_page: 6)
    # @project_feed = Kaminari.paginate_array(@projects.order(updated_at: :desc)).page(params[:page]).per(6)

  end

  def show
    begin
      @project = Project.find(params[:id])
      projects = Project.by_city(@current_city).not_completed_or_accepted.order(created_at: :desc).group(:id).first(10).map(&:id)
      position = projects.find_index(@project.id)
      @next_element = position.present? ? projects[position + 1] : nil
      @previous_element = (!position.present? || position == 0 ) ? nil  : projects[position-1] 
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: business_profile_index_path)
      flash[:error] = "That project is unavailable."
      return
    end

    #authorize @project
    if current_business
      @conversation_messages = @project.messages_with_business(current_business).order(created_at: :asc)
      @active = current_business.shortlisted_or_accepted?(@project)

      mark_as_read
    end
  end

  def mark_as_read
    current_business.incoming_notifications
      .where(project_id: @project.id).each{ |notification| notification.mark_as_read }

    @conversation_messages.where(receiving_user_id: current_business.id).each{ |message| message.mark_as_read }

  end

  def sort_apply_filter
    get_projects 
    category_ids = params[:filter][:category_ids].compact.uniq.flatten
    category_ids = category_ids - ["", " "]
    timeline_types = params[:filter][:timeline_types].compact.uniq.flatten
    timeline_types = timeline_types - ["", " "]
    city_ids = params[:filter][:city_id]

    @project_feed = handle_sorting_with_category_city(@projects, category_ids, city_ids, timeline_types)
    #@project_feed = Kaminari.paginate_array(projects.order(updated_at: :desc)).page(params[:page]).per(6)
  end

  private

  def pundit_user
    current_business
  end

  def policy(record)
    Business::ProjectFeedPolicy.new(current_business, record)
  end

  def user_not_authorised
    redirect_back(fallback_location: business_profile_index_path)
    if current_business.disabled?
      flash[:error] = "Your business has been disabled"
    else
      flash[:error] = "Sorry, you must be a standard or premium business to view projects from the project feed."
    end
  end

  def get_projects
    @projects = policy_scope(Project).includes(:translations)
      .completed
    if @current_business
      @projects = @projects.by_city(@current_business.cities)
        .not_hidden(@current_business.hidden_resources.pluck(:project_id))
        .not_applied(@current_business.applied_to_projects.pluck(:project_id))
        # .approved
      end
  end


end
