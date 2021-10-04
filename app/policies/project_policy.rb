class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  FREE_USER_PROJECT_LIMIT = (Rails.env == 'development' ? Float::INFINITY : 3)
  FREE_USER_PROJECT_REFRESH = 1.month.ago
  STANDARD_BUSINESS_PROJECT_DELAY = 10.hours.ago

  def initialize(user, project)
    @user = user
    @project = project
  end

  def index?
    !user.disabled?
  end

  def new?
    user.pro? || (user.projects.count < FREE_USER_PROJECT_LIMIT || 
                  user.projects.last.created_at < FREE_USER_PROJECT_REFRESH)
  end

  def show?
    is_owner?(@project)
  end

  def edit?
    is_owner?(@project)
  end

  def update?
    is_owner?(@project)
  end

  def destroy?
    is_owner?(@project)
  end

  class Scope
    attr_reader :current_business, :scope

    def initialize(current_business, scope)
      @current_business = current_business
      @scope = scope
    end

    def resolve
      current_business && current_business.premium? ? scope.all : scope.where("projects.created_at < ?", STANDARD_BUSINESS_PROJECT_DELAY)
    end

  end

end
