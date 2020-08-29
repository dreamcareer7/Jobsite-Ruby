class Admin::VendorPolicy < ApplicationPolicy

  def index?
    @user.superadmin? || @user.data_manager?
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

end
