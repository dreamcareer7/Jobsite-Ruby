class Admin::BusinessPolicy < ApplicationPolicy

  def index?
    !@user.moderator?
  end

  def destroy?
    @user.superadmin?
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

  def disable?
    index?
  end

  def enable?
    index?
  end

  def delete_photo?
    index?
  end

  def dissociate_owner?
    index?
  end

  def clear_business_hours?
    index?
  end

  class Scope < Scope
    def resolve
      #using includes to businesses with no location are shown
      scope.includes(
        locations: :city
      ).where(
        cities: {
          id: @user.accessible_city_ids
        }
      )
    end
  end

end
