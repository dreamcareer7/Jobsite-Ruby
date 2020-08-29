class Admin::CategoryPolicy < ApplicationPolicy

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

end
