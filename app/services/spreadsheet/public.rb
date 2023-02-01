module Spreadsheet
  class Public < Spreadsheet::Base
    FILENAME_SUFFIX = :public

    def build
      row_1_arr = []
      row_2_arr = ['№ п/п', 'Код доступу', 'Код перевірки',
        'Прізвище, ім\'я, по батькові', 'Навчальний заклад', 'Клас', 'Практичний'] +
                  Array.new(@tasks.size - 1) { '' } + ['∑', 'Місце']
      row_3_arr = ['', '',  '',  '', '', ''] + @tasks.map(&:display_name) + ['', '']
      # #,secret,secret,Name,institution,grade,tasks...,sum,place
      column_widths = [5, 11, 11, 45, 45, 10] + Array.new(@tasks.size) { 9 } + [10, 10]
      last_task_column = ('G'.ord + @tasks.size - 1).chr
      sum_column = last_task_column.next
      place_column = sum_column.next

      package = Axlsx::Package.new
      package.workbook do |workbook|
        title_style = workbook.styles.add_style TITLE_STYLE_OPTIONS.deep_dup
        header_style = workbook.styles.add_style HEADER_STYLE_OPTIONS.deep_dup
        data_style = workbook.styles.add_style DATA_STYLE_OPTIONS.deep_dup

        @grades.each do |grade|
          Rails.logger.debug { "Processing #{grade} grade of contest ##{@contest.id}..." }

          workbook.add_worksheet name: "#{grade} клас" do |sheet|
            sheet.add_row ["#{@contest.display_name}          #{grade} клас"], style: title_style
            # Merge only after all data, otherwise will be ignored
            sheet.merge_cells "A1:#{place_column}1"

            sheet.add_row row_1_arr
            sheet.add_row row_2_arr, style: header_style
            sheet.add_row row_3_arr, style: header_style

            # Merge only after all data, otherwise will be ignored
            sheet.merge_cells 'A3:A4'
            sheet.merge_cells 'B3:B4'
            sheet.merge_cells 'C3:C4'
            sheet.merge_cells 'D3:D4'
            sheet.merge_cells 'E3:E4'
            sheet.merge_cells 'F3:F4'
            sheet.merge_cells "G3:#{last_task_column}3"
            sheet.merge_cells "#{sum_column}3:#{sum_column}4"
            sheet.merge_cells "#{place_column}3:#{place_column}4"

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
      [user.secret, user.judge_secret, user.name, user.institution]
    end
  end
end
