class AddSleepServicesToContests < ActiveRecord::Migration[7.2]
  def change
    add_column :contests, :sleep_services, :integer, array: true, null: false, default: []
  end
end
