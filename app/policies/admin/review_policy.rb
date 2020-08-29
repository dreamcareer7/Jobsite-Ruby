class Admin::ReviewPolicy < ApplicationPolicy

  def index?
    !@user.sales?
  end

  def show?
    !@user.sales?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    def resolve
      scope.joins(
        business: {
          locations: :city
        }
      )
      .where(
        cities: {
          id: @user.accessible_city_ids
        }
      )
    end
  end

end
