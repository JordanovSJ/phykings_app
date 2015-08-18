require 'test_helper'

class AdminAndModeratorAccessTest < ActionDispatch::IntegrationTest
	def setup	
		@admin=users(:elza)
		@moderator=users(:gen4o)
		@creator=users(:go6o) # creator of the problem
		@problem=problems(:problem1_by_user1)
		@user2=users(:pe6o) #solver of the problem
		@relation=get_custom_relation(@user2,@problem)
		@solution=get_custom_solution(@relation)
		@solution_params=get_params_for_solution
	end
	
	#problems
	#admin	
	test "admin can see/edit/delete problem" do
		sign_in_as(@admin)
		get problem_path(@problem)
		assert_template 'problems/show' 
		get edit_problem_path(@problem)
		assert_template 'problems/edit' , flash[:danger]
		patch problem_path(@problem), problem: {answer: 10 }
		@problem.reload
		assert @problem.answer==10
		assert_difference 'Problem.count', -1 do
      delete problem_path(@problem)
    end
	end
	
	#moderator
	test "moderator can see problem but cannot update/delete" do
		sign_in_as(@moderator)
		get problem_path(@problem)
		assert_template 'problems/show' 
		get edit_problem_path(@problem)
		assert_redirected_to root_path
		patch problem_path(@problem), problem: {answer: 10 }
		@problem.reload
		assert_not @problem.answer==10
		assert_no_difference 'Problem.count' do
      delete problem_path(@problem)
    end
	end
	
	#solutions
	#admin
	test "admin can see/create/edit/delete solutiosn" do
		sign_in_as(@admin)
		get solution_path(@solution)
		assert_template 'solutions/show' 		
		get edit_solution_path(@solution)
		assert_template 'solutions/edit' 
		patch solution_path(@solution), solution: {answer: 10 }
		@solution.reload
		assert @solution.answer==10	
		assert_difference 'Solution.count', -1 do
      delete solution_path(@solution)
    end
    assert_difference 'Solution.count', 1 do
			post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end
	end
	
	#moderator
	test "moderator can see/create solutiosn but cannot edit/delete" do
		sign_in_as(@moderator)
		get solution_path(@solution)
		assert_template 'solutions/show' 		
		get edit_solution_path(@solution)
		assert_redirected_to root_path
		assert_not flash.empty?
		patch solution_path(@solution), solution: {answer: 10 }
		@solution.reload
		assert_not @solution.answer==10	
		assert_redirected_to root_path
		assert_not flash.empty?
		assert_no_difference 'Solution.count' do
      delete solution_path(@solution)
    end
    assert_difference 'Solution.count', 1 do
			post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end
	end
	
end
