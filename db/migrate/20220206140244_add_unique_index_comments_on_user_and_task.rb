class AddUniqueIndexCommentsOnUserAndTask < ActiveRecord::Migration[6.1]
  def change
    add_index :comments, %i[user_id task_id], unique: true
  end
end
