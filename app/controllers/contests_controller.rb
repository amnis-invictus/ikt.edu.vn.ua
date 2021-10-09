class ContestsController < ApplicationController
  private

  def contest
    @contest = Contest.find params[:id]
  end
end
