class Business::ProjectFeedPolicy < ApplicationPolicy

  def index?
    !@user.disabled?
  end

  def show?
    @user.trusted? && !@user.disabled?
  end

end
