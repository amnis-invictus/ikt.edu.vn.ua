class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    contest.registration_open? && !contest.archived?
  end
end
