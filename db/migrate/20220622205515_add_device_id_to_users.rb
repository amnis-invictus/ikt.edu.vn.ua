class AddDeviceIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :device_id, :uuid
  end
end
