require 'test_helper'

class AdminAndModeratorAccessTest < ActionDispatch::IntegrationTest
	def setup	
		@admin=users(:ivan)
		@moderator=users(:gen4o)
		@creator=users(:go6o) # creator of the problem
		@problem=problems(:problem1_by_user1)
		#@user2=users(:pe6o) #solver of the problem
		#@user3=users(:stamat) #has not relation to the problem
		#@relation=get_custom_relation(@user2,@problem)
		#@solution=get_custom_solution(@relation)
		#@problem_params=get_params_for_problem
		#@solution_params=get_params_for_solution
	end
	
	#admin
	#problems
	test "admin can see/edit/delete problem" do
		sign_in_as(@admin)
		get problem_path(@problem)
		assert_template 'problems/show'
		get edit_problem_path(@problem)
		assert_template 'problems/edit'
		patch problem_path(@problem), problem: {answer: 10 }
		@problem.reload
		assert @problem.answer==10
		assert_difference 'Problem.count', -1 do
      delete problem_path(@problem)
    end
	end
end
