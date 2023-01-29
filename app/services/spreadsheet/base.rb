module Spreadsheet
  class Base
    ALIGNMENT = { wrap_text: true, horizontal: :center, vertical: :center }.freeze
    BORDER_HEADER = { style: :medium, color: '000000', edges: %i[right top left bottom] }.freeze
    BORDER_DATA = BORDER_HEADER.merge({ style: :thin })
    HEADER_STYLE_OPTIONS = { sz: 12, b: true, alignment: ALIGNMENT, border: BORDER_HEADER }.freeze
    DATA_STYLE_OPTIONS = { sz: 11, alignment: ALIGNMENT, border: BORDER_DATA }.freeze
    TITLE_STYLE_OPTIONS = { sz: 14, alignment: ALIGNMENT }.freeze

    def initialize contest
      @contest = contest
      @path = "/tmp/result_#{contest.id}_#{self.class::FILENAME_SUFFIX}.xlsx"

      @tasks = contest.tasks
      @users = contest.users
      @grades = @users.map(&:grade).uniq

      @data = generate_data
    end

    private

    def generate_data
      data = {}

      @grades.each do |grade|
        data[grade] = @users.where(grade:).map do |user|
          results = Result.where(user:)

          {
            user:,
            results:,
            solutions: Solution.where(user:),
            final_score: results.sum(&:score),
          }
        end

        data[grade].sort! { |a, b| b[:final_score] <=> a[:final_score] }
      end

      data
    end
  end
end
