class AddAbsentToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :absent, :boolean, default: false, null: false
  end
end
