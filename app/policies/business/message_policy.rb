class Business::MessagePolicy < ApplicationPolicy

  def create?
    !@user.disabled?
  end

  def show?
    !@user.disabled?
  end

end

