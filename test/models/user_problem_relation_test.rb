require 'test_helper'

class UserProblemRelationTest < ActiveSupport::TestCase

	def setup
		@user=users(:go6o)
		@problem=problems(:problem2_by_user1)
		@user_problem_relation=UserProblemRelation.new(viewer_id: @user.id,
														seen_problem_id: @problem.id)
	end

	test "relation must be valid" do
		assert @user_problem_relation.valid?
	end
	
	
	test "solved_problem_id must be present" do
		@user_problem_relation.seen_problem_id=nil
		assert_not @user_problem_relation.valid?
	end
	
	test "viewer_id may not be present" do
		@user_problem_relation.viewer_id=nil
		assert @user_problem_relation.valid?
	end
	
end
