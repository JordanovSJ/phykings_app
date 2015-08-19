class AddSolutionVotesToUserProblemRelations < ActiveRecord::Migration
  def change
    add_column :user_problem_relations, :voted_solution, :boolean, default: false
    add_column :user_problem_relations, :solution_vote, :boolean
  end
end
