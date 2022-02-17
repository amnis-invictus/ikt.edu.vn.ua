class AddStatisticOpenToContests < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :statistic_open, :boolean, null: false, default: false
  end
end
