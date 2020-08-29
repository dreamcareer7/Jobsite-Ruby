class Business::InboxPolicy < ApplicationPolicy

  def index?
    !@user.disabled?
  end

  def show?
    !@user.disabled?
  end

end
