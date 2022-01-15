class StatisticsController < ApplicationController
  skip_before_action :authorize_collection, only: :index

  private

  def collection
    @collection ||= contest.users.order(:id).map { StatisticsItem.new user: _1 }
  end
end
