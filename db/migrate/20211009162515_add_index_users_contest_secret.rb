class AddIndexUsersContestSecret < ActiveRecord::Migration[6.1]
  def change
    add_index :users, %i[contest_id secret]
  end
end
