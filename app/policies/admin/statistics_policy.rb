class Admin::StatisticsPolicy < ApplicationPolicy

  def general?
    @user.superadmin? || @user.data_manager?
  end

  def engagement?
    general?
  end

  def businesses?
    general?
  end

  def users?
    general?
  end

  def categories?
    general?
  end

  def analytics?
    general?
  end

end
