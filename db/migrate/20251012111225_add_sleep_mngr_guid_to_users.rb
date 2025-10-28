class AddSleepMngrGuidToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :sleep_mngr_guid, :string, null: true
  end
end
