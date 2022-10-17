class AddJudgeSecretToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :judge_secret, :string

    change_column_null :users, :judge_secret, false, -> { 'secret' }
  end
end
