class AddScoringOpenToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :scoring_open, :boolean, null: false, default: true
  end
end
