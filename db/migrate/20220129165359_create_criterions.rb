class CreateCriterions < ActiveRecord::Migration[6.1]
  def change
    create_table :criterions do |t|
      t.string :name, null: false, default: ''
      t.integer :position, null: false
      t.float :limit, null: false, default: 0
      t.belongs_to :task, index: true, null: false, foreign_key: { to_table: :tasks }
      t.timestamps
    end
  end
end
