class AddTrialToUser < ActiveRecord::Migration
  def change
    add_column :users, :trial_started_at, :datetime
  end
end
