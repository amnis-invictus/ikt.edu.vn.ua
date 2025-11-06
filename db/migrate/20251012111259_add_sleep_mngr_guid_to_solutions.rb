class AddSleepMngrGuidToSolutions < ActiveRecord::Migration[7.2]
  def change
    add_column :solutions, :sleep_mngr_guid, :string, null: true
  end
end
