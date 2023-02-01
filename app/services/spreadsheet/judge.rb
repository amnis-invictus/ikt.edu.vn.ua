module Spreadsheet
  class Judge < Spreadsheet::Base
    FILENAME_SUFFIX = :judge

    def build
      row_1_arr = ['№ п/п', 'Код перевірки', 'Клас', 'Практичний'] +
                  Array.new(@tasks.size - 1) { '' } + ['∑', 'Місце']
      row_2_arr = ['', '', ''] + @tasks.map(&:display_name) + ['', '']
      # #,secret,grade,tasks...,sum,place
      column_widths = [5, 11, 10] + Array.new(@tasks.size) { 9 } + [10, 10]
      last_task_column = ('D'.ord + @tasks.size - 1).chr
      sum_column = last_task_column.next
      place_column = sum_column.next

      package = Axlsx::Package.new
      package.workbook do |workbook|
        header_style = workbook.styles.add_style HEADER_STYLE_OPTIONS.deep_dup
        data_style = workbook.styles.add_style DATA_STYLE_OPTIONS.deep_dup

        @grades.each do |grade|
          Rails.logger.debug { "Processing #{grade} grade of contest ##{@contest.id}..." }

          workbook.add_worksheet name: "#{grade} клас" do |sheet|
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

    def user_data_row user
      [user.judge_secret]
    end
  end
end
