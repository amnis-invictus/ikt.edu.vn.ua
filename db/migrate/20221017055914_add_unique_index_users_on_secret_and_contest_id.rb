class AddUniqueIndexUsersOnSecretAndContestId < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, %i[contest_id secret]
    add_index :users, %i[contest_id secret], unique: true
  end
end
