class AddUniqueIndexToResults < ActiveRecord::Migration[6.1]
  def change
    add_index :results, %i[user_id task_id], unique: true
  end
end
