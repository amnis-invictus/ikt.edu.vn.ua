class ChangeSecretsToCitext < ActiveRecord::Migration[7.2]
  def up
    change_column :users, :secret, :citext
    change_column :contests, :registration_secret, :citext
  end

  def down
    change_column :users, :secret, :string
    change_column :contests, :registration_secret, :string
  end
end
