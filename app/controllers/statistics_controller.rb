class StatisticsController < ApplicationController
  private

  def collection
    @collection ||= contest.users.map { StatisticsItem.new user: _1 }
  end
end
