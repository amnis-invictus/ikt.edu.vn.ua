class ContestsController < ApplicationController
  skip_before_action :authorize_resource, :authorize_collection

  private

  def contest
    @contest ||= Contest.find params[:id]
  end

  def collection
    @collection ||= Contest.where archived: true
  end
end
