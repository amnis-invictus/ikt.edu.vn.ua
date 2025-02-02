class JudgesController < ApplicationController
  include ContestAuthentication[:judge]

  def users_csv
    send_data UsersList.new(contest, params[:separator]).build_csv, filename: 'users-list.csv'
  end

  def judge_xlsx
    send_file Spreadsheet::Judge.new(contest).build
  end

  def destroy
    sign_out
    redirect_to contest
  end
end
