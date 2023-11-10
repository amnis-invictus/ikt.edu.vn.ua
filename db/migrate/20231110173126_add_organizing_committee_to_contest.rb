class AddOrganizingCommitteeToContest < ActiveRecord::Migration[7.0]
  def change
    change_table :contests, bulk: true do |t|
      t.string :head_of_organizing_committee, null: false, default: ''
      t.string :secretary_of_organizing_committee, null: false, default: ''
    end
  end
end
