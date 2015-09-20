class AddVotedToUserSolutionRelations < ActiveRecord::Migration
  def change
    add_column :user_solution_relations, :voted, :boolean, default: false
  end
end
