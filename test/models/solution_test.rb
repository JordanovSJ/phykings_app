require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
	def setup 
		@solution=Solution.new(content: "content", user_problem_relation_id: 1)
	end
	
	test "solution should be valid" do
		assert @solution.valid?
	end
	
	test "content should not be empty" do
		@solution.content="   "
		assert_not @solution.valid?
	end

	test "content should not be more than 3000 charachters" do
		@solution.content="a"*3001
		assert_not @solution.valid?
	end
	
	test "user_problem_relation_id must be prensent" do
		@solution.user_problem_relation_id=nil
		assert_not @solution.valid?
	end

end

