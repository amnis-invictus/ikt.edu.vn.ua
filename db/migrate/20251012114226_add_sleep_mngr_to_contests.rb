class AddSleepMngrToContests < ActiveRecord::Migration[7.2]
  def change
    add_column :contests, :sleep_mngr, :integer, null: false, default: 0
  end
end
