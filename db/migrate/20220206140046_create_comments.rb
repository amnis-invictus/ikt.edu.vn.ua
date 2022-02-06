class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.belongs_to :task, index: true, null: false, foreign_key: { to_table: :tasks }
      t.belongs_to :user, index: true, null: false, foreign_key: { to_table: :users }
      t.text :value, null: false, default: ''
      t.timestamps
    end
  end
end
