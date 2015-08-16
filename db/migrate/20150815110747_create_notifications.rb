class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :seen, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :notifications, [:user_id, :created_at]
  end
end
