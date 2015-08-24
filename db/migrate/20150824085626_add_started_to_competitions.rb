class AddStartedToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :started_at, :datetime
  end
end
