class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.belongs_to :contest, index: true, foreign_key: { to_table: :contests }
      t.citext :name
      t.citext :email
      t.string :region
      t.string :city
      t.string :institution
      t.string :contest_site
      t.integer :grade
      t.string :secret
      t.inet :registration_ips, array: true, null: false, default: []
      t.timestamps
    end
  end
end
