class AddUniqueIndexUsersOnJudgeSecretAndContestId < ActiveRecord::Migration[6.1]
  def change
    add_index :users, %i[contest_id judge_secret], unique: true
  end
end
