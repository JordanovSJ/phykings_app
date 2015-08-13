require 'test_helper'

class DestroyDependenciesTest < ActionDispatch::IntegrationTest
	def setup
		@creator=users(:go6o)
		@solver=users(:pe6o)
		@problem=get_custom_problem(@creator)
		@relation=get_custom_relation(@solver,@problem)
		@solution=get_custom_solution(@relation)
	end
	
	test "when a relation is detroyed its solution should be detroyed too" do
		 assert_difference 'Solution.count', -1 do
      @relation.destroy
    end
	end
	
	test "when a problem is detroyed its corresponding relations be detroyed" do
		assert_difference 'UserProblemRelation.count', -1 do
      @problem.destroy
    end
	end
	
	test "when a problem is detroyed its corresponding solutions should be detroyed" do
		assert_difference 'Solution.count', -1 do
      @problem.destroy
    end
	end
end
