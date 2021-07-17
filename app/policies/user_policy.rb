class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  #
  # Admin only actions
  #
  def index?
    if @user.instance_of? Admin
      return true
    end

    false
  end

  def destroy?
    if @user.instance_of? Admin
      return true
    end

    false
  end

  #
  # Shared actions
  #
  def show?
    if @user.instance_of? Admin
      return true
    elsif @user.instance_of? User 
      if @user == @record
        return true
      end
    end

    false
  end

  def update?
    if @user.instance_of? Admin
      return true
    elsif @user.instance_of? User 
      return true
    end
    false
  end 

  def edit?
    update?
  end

  #
  # User only actions
  #
  def profile?
    if @user.instance_of? User 
      if @user == @record
        return true
      end
    end
  end

  def tickets?
    if @user.instance_of? User 
      if @user == @record
        return true
      end
    end
  end  

  #
  # Open actions
  #
  def create?
    true
  end

  def new?
    create?
  end

  #
  # Creating Scope of policy
  # 
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
