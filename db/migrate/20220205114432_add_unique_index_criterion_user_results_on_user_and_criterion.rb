class AddUniqueIndexCriterionUserResultsOnUserAndCriterion < ActiveRecord::Migration[6.1]
  def change
    add_index :criterion_user_results, %i[user_id criterion_id], unique: true
  end
end
