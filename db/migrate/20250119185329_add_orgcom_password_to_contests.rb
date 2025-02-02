class AddOrgcomPasswordToContests < ActiveRecord::Migration[7.2]
  def change
    add_column :contests, :orgcom_password, :string # rubocop:disable Rails/BulkChangeTable
    change_column_null :contests, :orgcom_password, false, -> { 'judge_password' }
  end
end
