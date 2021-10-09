class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.belongs_to :user, index: true, foreign_key: { to_table: :users }
      t.belongs_to :task, index: true, foreign_key: { to_table: :tasks }
      t.float :score, null: false, default: 0
      t.timestamps
    end
  end
end
