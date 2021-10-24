class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    contest.registration_open?
  end
end
