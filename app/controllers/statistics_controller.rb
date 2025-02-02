class StatisticsController < ApplicationController
  private

  def collection
    @collection ||= contest.users.order(:id).map { StatisticsItem.new user: _1 }
  end
end
