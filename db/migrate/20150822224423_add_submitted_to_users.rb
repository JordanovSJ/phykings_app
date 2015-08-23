class AddSubmittedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :submitted_competition, :boolean, default: false
  end
end
