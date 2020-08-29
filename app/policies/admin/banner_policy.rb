class Admin::BannerPolicy < ApplicationPolicy

  def index?
    @user.superadmin? || @user.data_manager?
  end

  def show?
    index?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  def disable?
    index?
  end

  def enable?
    index?
  end

  class Scope < Scope
    def resolve
      scope.includes(
        banner_targets: {
          target_location: :cities
        }
      ).where(
        cities: {
          id: @user.accessible_city_ids
        }
      ).references(:target_location)
    end
  end

end
