class AddCriterionsCountToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :criterions_count, :integer, null: false, default: 0
  end
end
