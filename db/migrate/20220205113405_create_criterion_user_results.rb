class CreateCriterionUserResults < ActiveRecord::Migration[6.1]
  def change
    create_table :criterion_user_results do |t|
      t.belongs_to :criterion, index: true, null: false, foreign_key: { to_table: :criterions }
      t.belongs_to :user, index: true, null: false, foreign_key: { to_table: :users }
      t.float :value, null: false, default: 0
      t.timestamps
    end
  end
end
