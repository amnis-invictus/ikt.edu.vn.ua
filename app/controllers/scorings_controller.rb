class ScoringsController < ApplicationController
  private

  def authorize_resource
    http_basic_authenticate_or_request_with name: 'judge', password: contest.judge_password
    session[:judge_contest] = contest.id
  end
end
