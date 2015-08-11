class AddTypeToUserProblemRelation < ActiveRecord::Migration
  def change
		#is the problem rated
    add_column :user_problem_relations, :rated, :boolean, default: false
    #type
    add_column :user_problem_relations, :attempted_during_free, :boolean, 
								default: false
    add_column :user_problem_relations, :attempted_during_premium, :boolean,
								default: false
    add_column :user_problem_relations, :solved_during_free, :boolean, 
								default: false
    add_column :user_problem_relations, :solved_during_premium, :boolean, 
								default: false
    add_column :user_problem_relations, :provided_with_solution, :boolean, 
								default: false
  end
end
