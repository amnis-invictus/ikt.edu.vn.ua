class UsersList
  HEADERS = %w[secret grade].freeze

  def initialize contest, separator
    @contest = contest
    @separator = separator
  end

  def build_csv
    CSV.generate headers: HEADERS, write_headers: true, col_sep: @separator do |csv|
      @contest.users.each { csv << [_1.judge_secret, _1.grade] }
    end
  end
end
