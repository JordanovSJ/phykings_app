class AddSubmittedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :submitted_at, :datetime
  end
end
