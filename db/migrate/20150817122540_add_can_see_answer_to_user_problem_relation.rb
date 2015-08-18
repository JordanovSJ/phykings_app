class AddCanSeeAnswerToUserProblemRelation < ActiveRecord::Migration
  def change
    add_column :user_problem_relations, :can_see_answer, :boolean, default: false
  end
end
