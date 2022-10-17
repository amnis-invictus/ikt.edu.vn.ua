class AddDeviceIdToSolutions < ActiveRecord::Migration[6.1]
  def change
    add_column :solutions, :device_id, :uuid
  end
end
