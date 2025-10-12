class AddMetadataSecretToUser < ActiveRecord::Migration[7.2]
  def change
    # rubocop:disable Rails/BulkChangeTable
    # We need to add a column without default first and
    # then set values for all existing rows
    add_column :users, :metadata_secret, :string

    change_column_null :users, :metadata_secret, false, -> { 'secret' }
    # rubocop:enable Rails/BulkChangeTable
  end
end
