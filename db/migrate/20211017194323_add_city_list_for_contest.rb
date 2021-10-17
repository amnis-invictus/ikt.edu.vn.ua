class AddCityListForContest < ActiveRecord::Migration[6.1]
  def change
    add_column :contests, :cities, :string, null: false, array: true, default: []
  end
end
