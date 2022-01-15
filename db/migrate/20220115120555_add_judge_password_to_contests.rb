class AddJudgePasswordToContests < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :judge_password, :string
    change_column_null :contests, :judge_password, false, '3ee6602bbd'
  end
end
