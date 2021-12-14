class RafflePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    if (controller_name = 'institution/raffles')
      if @user.instance_of? Institution 
        return true 
      else
        return false # E um instituicao
      end
    end
    return true
  end

  def show?
    false
  end

  def buy?
    if @user.instance_of? User # e admin?
      if @user == @record
        return true
      end
    end
    return false
  end

  def check_tickets?
    buy?
  end

  def checkout?
    buy?
  end

  def cancel?
    buy?
  end

  def finish?
    buy?
  end

 #
 # Apenas o usuario confirma o recebimento
 #
 def confirm_received?
    if @user.instance_of? User 
      if @user == record.winner_ticket.user
        return true
      end
    end
    return false
  end

 #
 # Apenas a instituição confirma o envio
 #
 def confirm_sended?
    if @user.instance_of? Institution 
      if @user == record.institution
        return true
      end
    end
    return false
  end

  def create?
    if @user.instance_of? Admin # e admin?
      return true
    elsif @user.instance_of? Institution # E um instituicao
      if record.institution = @user # A campanha pertence a intituicao logada
        return true
      end
    end
    false
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
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
