class AddJudgesToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :judges, :string, null: false, array: true, default: []
  end
end
