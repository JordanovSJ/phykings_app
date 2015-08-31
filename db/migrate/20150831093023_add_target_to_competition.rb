class AddTargetToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :target, :integer
  end
end
