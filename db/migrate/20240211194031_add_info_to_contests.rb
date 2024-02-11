class AddInfoToContests < ActiveRecord::Migration[7.0]
  def change
    add_column :contests, :info, :text, null: false, default: ''
  end
end
