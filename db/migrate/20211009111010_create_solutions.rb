class CreateSolutions < ActiveRecord::Migration[6.1]
  def change
    create_table :solutions do |t|
      t.belongs_to :user, index: true, foreign_key: { to_table: :users }
      t.belongs_to :task, index: true, foreign_key: { to_table: :tasks }
      t.inet :ips, array: true, null: false, default: []
      t.timestamps
    end
  end
end
