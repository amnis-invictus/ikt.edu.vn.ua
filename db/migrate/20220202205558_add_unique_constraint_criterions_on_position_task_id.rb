class AddUniqueConstraintCriterionsOnPositionTaskId < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL.squish
      ALTER TABLE criterions
      ADD CONSTRAINT criterions_position_and_task_id_unique
      UNIQUE (position, task_id) DEFERRABLE INITIALLY DEFERRED
    SQL
  end

  def down
    execute 'ALTER TABLE criterions DROP CONSTRAINT criterions_position_and_task_id_unique'
  end
end
