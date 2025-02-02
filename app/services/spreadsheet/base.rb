module Spreadsheet
  class Base
    ALIGNMENT = { wrap_text: true, horizontal: :center, vertical: :center }.freeze
    BORDER_HEADER = { style: :medium, color: '000000', edges: %i[right top left bottom] }.freeze
    BORDER_DATA = BORDER_HEADER.merge({ style: :thin })
    HEADER_STYLE_OPTIONS = { sz: 12, b: true, alignment: ALIGNMENT, border: BORDER_HEADER }.freeze
    JUDGES_STYLE_OPTIONS = { sz: 12 }.freeze
    DATA_STYLE_OPTIONS = { sz: 11, alignment: ALIGNMENT, border: BORDER_DATA }.freeze
    TITLE_STYLE_OPTIONS = { sz: 14, alignment: ALIGNMENT }.freeze
    USERS_SELECT_SQL = <<-SQL.squish.freeze
      users.*,
      sum(results.score) as final_score,
      json_agg(json_build_array(results.task_id, results.score)) as task_to_result,
      array_agg(distinct solutions.task_id) as tasks_with_solutions
    SQL

    def initialize contest
      @contest = contest
      @path = "/tmp/result_#{contest.id}_#{self.class::FILENAME_SUFFIX}.xlsx"
      @tasks = contest.tasks.load
      @data = generate_data
    end

    private

    def generate_data
      score_and_results = @contest.users.left_joins(:results).group(:id).pluck(
        'users.id',
        Arel.sql('coalesce(sum(results.score), 0) as final_score'),
        Arel.sql('json_agg(json_build_array(results.task_id, results.score)) as task_to_result'),
      ).index_by(&:first)
      solutions = @contest.users.left_joins(:solutions).group(:id).pluck(
        'users.id',
        Arel.sql('array_agg(distinct solutions.task_id) as tasks_with_solutions'),
      ).to_h.transform_values! { Set.new _1 }
      data = @contest.users.map do |user|
        {
          user:,
          results: score_and_results[user.id][2].to_h,
          solutions: solutions[user.id],
          final_score: score_and_results[user.id][1],
        }
      end
      data.sort! { |a, b| b[:final_score] <=> a[:final_score] }
    end

    def generate_data_rows *grades
      @data.filter { grades.include? _1[:user].grade }.map.with_index 1 do |dt, index|
        row = [index]
        row.concat user_data_row dt[:user]
        row.concat tasks_data_row dt[:results], dt[:solutions]
        row << dt[:final_score]
        row << ''
        row
      end
    end

    def tasks_data_row results, solutions
      @tasks.map do |task|
        result_score = results[task.id]
        solution = solutions.include? task.id

        case [solution, result_score]
        in [false, nil] # no solution, no result
          '---'
        in [true, nil]  # some solution, no result
          'XXX'
        in [false, ..0] # no solution, <= 0 result (OK)
          '--'
        in [false, _]   # no solution, MAGIC result
          "?: #{result_score}"
        in [true, _]    # some solution, some result
          result_score
        end
      end
    end
  end
end
