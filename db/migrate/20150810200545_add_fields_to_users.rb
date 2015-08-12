class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :free_level, :integer, default: 2000
    add_column :users, :premium_level, :integer, default: 2000
    add_column :users, :gold, :integer, default: 0
    add_column :users, :admin, :boolean, default: false
    add_column :users, :moderator, :boolean, default: false
  end
end
