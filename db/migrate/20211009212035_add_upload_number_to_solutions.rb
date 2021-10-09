class AddUploadNumberToSolutions < ActiveRecord::Migration[6.1]
  def change
    add_column :solutions, :upload_number, :integer, null: false, default: 1

    add_index :solutions, %i[user_id task_id upload_number], unique: true
  end
end
