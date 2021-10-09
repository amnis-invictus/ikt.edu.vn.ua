class CreateContests < ActiveRecord::Migration[6.1]
  def change
    create_table :contests do |t|
      t.string :display_name
      t.text :content
      t.boolean :registration_open, null: false, default: false
      t.boolean :task_open, null: false, default: false
      t.boolean :upload_open, null: false, default: false
      t.boolean :archived, null: false, default: false
      t.string :registration_secret
      t.timestamps
    end
  end
end
