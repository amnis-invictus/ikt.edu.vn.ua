class AddHeadOfAppealCommissionToContests < ActiveRecord::Migration[7.0]
  def change
    add_column :contests, :head_of_appeal_commission, :string, null: false, default: ''
  end
end
