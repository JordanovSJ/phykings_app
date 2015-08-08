require 'test_helper'

class UserSolvedProblemRelationTest < ActiveSupport::TestCase
	def setup
		@user=users(:go6o)
		@problem=problems(:one)
		@relation=Relation.new(solver_id: @user.id,
														solved_problem_id: @problem.id)
	end

	test "relation must be valid" do
		assert @relation.valid?
	end
	
	test "solver_id must be present" do
		@relation.solver_id=nil
		assert_not @relation.valid?
	end
	
	test "solved_problem_id must be present" do
		@relation.solver_id=nil
		assert_not @relation.valid?
	end
	
end
