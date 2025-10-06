class ContestsController < ApplicationController
  helper_method :current_user

  private

  def contest
    @contest ||= Contest.available.find params[:id]
  end

  def collection
    @collection ||= Contest.available.where archived: true
  end

  def current_user
    @current_user ||= contest.users.find_by secret: params[:user_secret] if params[:user_secret].present?
  end
end
