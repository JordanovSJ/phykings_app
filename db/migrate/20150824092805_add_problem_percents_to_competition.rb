class AddProblemPercentsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :problems_percents, :text
  end
end
