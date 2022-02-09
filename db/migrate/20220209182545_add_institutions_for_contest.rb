class AddInstitutionsForContest < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :institutions, :string, null: false, array: true, default: []
  end
end
