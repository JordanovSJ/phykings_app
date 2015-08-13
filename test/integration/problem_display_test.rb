require 'test_helper'

class ProblemDisplayTest	< ActionDispatch::IntegrationTest
	
	def setup
		@problem=problems(:problem1_by_user1)
		@user=users(:go6o)
	end
	
	test "display problem" do
		sign_in_as(@user)
		assert_match "Signed in", response.body		
		get problem_path(@problem)
		assert_template 'problems/show'
		assert_match @problem.title, response.body
		assert_match @problem.content, response.body
		assert_match @problem.answer.to_s, response.body
		assert_match @problem.creator.first_name, response.body
		if @problem.viewers.count > 0
			assert_match @problem.viewers.first.first_name, response.body
		end
	end
	

	

end
