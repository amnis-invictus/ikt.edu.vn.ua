class AddResultMultiplierToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :result_multiplier, :string, default: '1', null: false
  end
end
