class AddArchiveOpenToContests < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :archive_open, :boolean, null: false, default: false
  end
end
