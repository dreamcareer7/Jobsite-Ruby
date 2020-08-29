class Admin::ReviewReply < ApplicationPolicy

  def index?
    !@user.sales?
  end

  def show?
    !@user.sales?
  end

  def destroy?
    index?
  end

end
