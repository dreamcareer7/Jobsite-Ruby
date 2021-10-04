class Business::ProjectFeedPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    @user.trusted? && !@user.disabled?
  end

end
