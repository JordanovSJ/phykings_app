class AddFinishedToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :finished, :boolean, default: false
  end
end
