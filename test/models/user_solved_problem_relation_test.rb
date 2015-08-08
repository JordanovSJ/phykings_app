require 'test_helper'

class UserSolvedProblemRelationTest < ActiveSupport::TestCase
	def setup
		@user=users(:go6o)
		@problem=problems(:one)
		@relation=UserSolvedProblemRelation.new(user_id: @user.id,
																								problem_id: @problem.id)
	end

	test "relation must be valid" do
		assert @relation.valid?
	end
	
	test "relation must not be valid" do
		@relation.user_id=nil
		assert_not @relation.valid?
	end
	
	
end
