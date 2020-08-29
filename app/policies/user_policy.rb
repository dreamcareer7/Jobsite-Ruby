class UserPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, target_user)
    @user = user
    @target_user = target_user
  end

  def edit?
    @user == @target_user
  end

  def update?
    @user == @target_user
  end

  def destroy?
    @user == @target_user
  end

end
