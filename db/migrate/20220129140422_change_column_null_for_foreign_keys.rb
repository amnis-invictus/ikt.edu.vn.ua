class ChangeColumnNullForForeignKeys < ActiveRecord::Migration[6.1]
  def change
    change_column_null :results, :user_id, false
    change_column_null :results, :task_id, false
    change_column_null :solutions, :user_id, false
    change_column_null :solutions, :task_id, false
    change_column_null :tasks, :contest_id, false
    change_column_null :users, :contest_id, false
  end
end
