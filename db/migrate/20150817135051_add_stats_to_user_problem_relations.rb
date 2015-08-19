class AddStatsToUserProblemRelations < ActiveRecord::Migration
  def change
    add_column :user_problem_relations, :rating, :integer
    add_column :user_problem_relations, :length, :integer
    add_column :user_problem_relations, :difficulty, :integer
    add_column :user_problem_relations, :voted, :boolean, default: false
  end
end
