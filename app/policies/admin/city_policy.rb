class Admin::CityPolicy < ApplicationPolicy

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

  def enable?
    index?
  end

  def disable?
    index?
  end

  class Scope < Scope
    def resolve
      scope.where(id: @user.accessible_city_ids)
    end
  end

end
