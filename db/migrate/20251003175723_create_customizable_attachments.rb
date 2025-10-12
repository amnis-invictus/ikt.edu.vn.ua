class CreateCustomizableAttachments < ActiveRecord::Migration[7.2]
  def change
    create_table :customizable_attachments do |t|
      t.belongs_to :contest, index: true, null: false, foreign_key: { to_table: :contests }
      t.integer :action, null: false, default: 0
      t.jsonb :options, null: false, default: {}

      t.timestamps
    end
  end
end
