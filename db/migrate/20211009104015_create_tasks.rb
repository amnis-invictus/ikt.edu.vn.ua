class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :display_name
      t.string :file_names, array: true, null: false, default: []
      t.integer :upload_limit, null: false, default: 1
      t.belongs_to :contest, index: true, foreign_key: { to_table: :contests }
      t.timestamps
    end
  end
end
