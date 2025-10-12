class ContestsController < ApplicationController
  private

  def contest
    @contest ||= Contest.available.find params[:id]
  end

  def collection
    @collection ||= Contest.available.where archived: true
  end
end
