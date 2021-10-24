class UploadPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    contest.upload_open?
  end

  def update?
    contest.upload_open?
  end
end
