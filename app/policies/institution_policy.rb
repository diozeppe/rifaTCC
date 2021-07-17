class InstitutionPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def institutions_approval?
    create?
  end

  def aprove_institution?
    create?
  end

  def index?
    if @user.instance_of? Admin
      return true
    end

    false
  end

  def show?
    if @user.instance_of? Admin
      return true
    elsif @user.instance_of? Institution 
      if @user == @record
        return true
      end
    end

    false
  end

  def update?
    if @user.instance_of? Admin
      return true
    elsif @user.instance_of? Institution 
      if @user == @record
        return true
      end
    end
    false
  end

  def profile?
    update?
  end

  def edit?
    update?
  end

  def create?
    if @user.instance_of? Admin
      return true
    end
    return false
  end

  def new?
    create?
  end

  def destroy?
    create?
  end

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
