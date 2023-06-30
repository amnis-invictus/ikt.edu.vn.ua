class AddMainJudgeToContest < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :main_judge, :string, null: false, default: ''
  end
end
