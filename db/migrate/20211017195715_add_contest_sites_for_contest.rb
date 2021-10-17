class AddContestSitesForContest < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :contest_sites, :string, null: false, array: true, default: []
  end
end
