class UploadPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    contest.upload_open? && !contest.archived?
  end

  def update?
    contest.upload_open? && !contest.archived?
  end
end
