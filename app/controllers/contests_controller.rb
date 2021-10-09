class ContestsController < ApplicationController
  private

  def resource
    @resource = Contest.find params[:id]
  end
end
