class BusinessPolicy < ApplicationPolicy
  attr_reader :user, :business

  def initialize(user, business)
    @user = user
    @business = business
  end

  def show?
    is_owner?(@business)
  end

  def edit?
    is_owner?(@business)
  end

  def update?
    is_owner?(@business)
  end

  def destroy?
    is_owner?(@business)
  end

  class Scope
    attr_reader :business, :scope

    def initialize(user, business)
      @user = user
      @business = business
    end

    def resolve
      @user == @business.user
    end

  end

end
