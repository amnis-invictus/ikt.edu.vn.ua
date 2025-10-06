class AddMetadataSecretToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :metadata_secret, :string, null: false, default: -> { 'gen_random_uuid()' }
  end
end
