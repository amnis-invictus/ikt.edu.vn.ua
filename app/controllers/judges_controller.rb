class JudgesController < ApplicationController
  def users_csv
    send_data UsersList.new(contest, params[:separator]).build_csv, filename: 'users-list.csv'
  end

  private

  def authorize_resource
    authenticate_or_request_with_http_basic &method(:login_procedure)
  end
end
