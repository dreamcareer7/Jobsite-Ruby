class Business::ProjectPolicy < ApplicationPolicy

  def index?
    !@user.disabled?
  end

  def show?
    !@user.disabled?
  end

end
