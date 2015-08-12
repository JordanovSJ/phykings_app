class AddCanSeeToUserProblemRelations < ActiveRecord::Migration
  def change
    add_column :user_problem_relations, :can_see_solution, :boolean, default: false
  end
end
