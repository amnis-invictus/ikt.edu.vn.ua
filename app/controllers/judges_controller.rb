class JudgesController < ApplicationController
  def users_csv
    send_data UsersList.new(contest, params[:separator]).build_csv, filename: 'users-list.csv'
  end

  private

  def authorize_resource
    http_basic_authenticate_or_request_with name: 'judge', password: contest.judge_password
  end
end
