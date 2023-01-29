module Spreadsheet
  class Judge < Spreadsheet::Base
    FILENAME_SUFFIX = :judge

    def build
      row_1_arr = ['№ п/п', 'Код перевірки', 'Клас', 'Практичний'] +
                  Array.new(@tasks.count - 1) { '' } + ['∑', 'Місце']
      row_2_arr = ['', '', ''] + @tasks.map(&:display_name) + ['', '']
      # #,secret,grade,tasks...,sum,place
      column_widths = [5, 11, 10] + Array.new(@tasks.count) { 9 } + [10, 10]

      package = Axlsx::Package.new
      package.workbook do |workbook|
        header_style = workbook.styles.add_style HEADER_STYLE_OPTIONS.deep_dup
        data_style = workbook.styles.add_style DATA_STYLE_OPTIONS.deep_dup

        @grades.each do |grade|
          Rails.logger.debug { "Processing #{grade} grade of contest ##{@contest.id}..." }

          workbook.add_worksheet name: "#{grade} клас" do |sheet|
            last_task_column = ('D'.ord + @tasks.length - 1).chr
            sum_column = (last_task_column.ord + 1).chr
            place_column = (sum_column.ord + 1).chr

            sheet.add_row row_1_arr, style: header_style
            sheet.add_row row_2_arr, style: header_style

            # Merge only after all data, otherwise will be ignored
            sheet.merge_cells 'A1:A2'
            sheet.merge_cells 'B1:B2'
            sheet.merge_cells 'C1:C2'
            sheet.merge_cells "D1:#{last_task_column}1"
            sheet.merge_cells "#{sum_column}1:#{sum_column}2"
            sheet.merge_cells "#{place_column}1:#{place_column}2"

            generate_data_rows(grade).each { |row| sheet.add_row row, style: data_style }

            # Set only after all data, otherwise will be ignored
            sheet.column_widths *column_widths
          end
        end
      end

      package.serialize @path
      @path
    end

    private

    def generate_data_rows grade
      @data[grade].map.with_index 1 do |dt, index|
        row = [index, dt[:user].judge_secret, grade]
        @tasks.each do |task|
          r = dt[:results].where(task:).first
          s = dt[:solutions].where(task:)

          if_map = (r.nil? ? 0 : 2) + (s.present? ? 1 : 0)
          case if_map
          when 0 # no solution, no result
            row << '---'
          when 1 # yes solution, no result
            row << 'XXX'
          when 2 # no solution, yes result
            row << if r.score.positive? # MAGIC
                     "?: #{r.score}"
                   else # result = 0 (OK)
                     '--'
                   end
          when 3 # yes solution, yes result
            row << r.score
          end
        end
        row << dt[:final_score]
        row << ''
        row
      end
    end
  end
end
