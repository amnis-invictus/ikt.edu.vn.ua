module Spreadsheet
  class Public < Spreadsheet::Base
    FILENAME_SUFFIX = :public

    def build
      row_1_arr = ['']
      row_2_arr = ['№ п/п', 'Код доступу', 'Код перевірки',
        'Прізвище, ім\'я, по батькові', 'Навчальний заклад', 'Клас', 'Практичний'] +
                  Array.new(@tasks.count - 1) { '' } + ['∑', 'Місце']
      row_3_arr = ['', '',  '',  '', '', ''] + @tasks.map(&:display_name) + ['', '']
      # #,secret,secret,Name,institution,grade,tasks...,sum,place
      column_widths = [5, 11, 11, 45, 45, 10] + Array.new(@tasks.count) { 9 } + [10, 10]

      package = Axlsx::Package.new
      package.workbook do |workbook|
        title_style = workbook.styles.add_style TITLE_STYLE_OPTIONS.deep_dup
        header_style = workbook.styles.add_style HEADER_STYLE_OPTIONS.deep_dup
        data_style = workbook.styles.add_style DATA_STYLE_OPTIONS.deep_dup

        @grades.each do |grade|
          Rails.logger.debug { "Processing #{grade} grade of contest ##{@contest.id}..." }

          workbook.add_worksheet name: "#{grade} клас" do |sheet|
            last_task_column = ('G'.ord + @tasks.length - 1).chr
            sum_column = (last_task_column.ord + 1).chr
            place_column = (sum_column.ord + 1).chr

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
            # #,secret,secret,Name,institution,grade,tasks...,sum,place
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
        row = [index, dt[:user].secret, dt[:user].judge_secret,
          dt[:user].name, dt[:user].institution, grade]
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
