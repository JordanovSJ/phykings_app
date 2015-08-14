require 'test_helper'

class ProblemsAndSolutionsIntegrationsTest < ActionDispatch::IntegrationTest

	def setup	
		@user1=users(:go6o) # creator of the problem
		@user2=users(:pe6o) #solver of the problem
		@user3=users(:stamat) #has not relation to the problem
		@problem=problems(:problem1_by_user1)
		@relation=get_custom_relation(@user2,@problem)
		@solution=get_custom_solution(@relation)
		@problem_params=get_params_for_problem
		@solution_params=get_params_for_solution
	end
	
	test "signed_out user cannot access problems" do
		get new_problem_path
		follow_redirect!
		assert_template 'devise/sessions/new'
		assert_not flash.empty?
		get problem_path(@problem)
		follow_redirect!
		assert_template 'devise/sessions/new'
		assert_not flash.empty?
		get edit_problem_path(@problem)
		follow_redirect!
		assert_template 'devise/sessions/new'
		assert_not flash.empty?		
	end
	
	test "get redirected to root if you try to acces a solution without such an id" do
		sign_in_as(@user1)
		get solution_path(10)
		assert_redirected_to root_path
		assert_not flash.empty?
	end
	
	test "user that has no relation to a problem cann see but cannot edit/delete that problem when the problem has no solution" do
		sign_in_as(@user1)	
		@relation.destroy
		get problem_path(problems(:problem1_by_user2))
		assert_template 'problems/show'
		get edit_problem_path(problems(:problem1_by_user2))
		follow_redirect!
		assert_template 'static_pages/home'
		assert_not flash.empty?			
	end
	
	test "user that has no relation to a problem cannot see that problem if that problem has solution" do
		sign_in_as(@user3)	
		get problem_path(@problem)
		follow_redirect!
		assert_template 'static_pages/home'
		assert_not flash.empty?	
	end
	
	
		test "signed_out user cannot access solutions actions" do
		get new_solution_path
		follow_redirect!
		assert_template 'devise/sessions/new'
		assert_match "Please log in" , response.body
		assert_not flash.empty? 
		get solution_path(@solution)
		follow_redirect!
		assert_template 'devise/sessions/new'
		assert_not flash.empty?
		get edit_solution_path(@solution)
		follow_redirect!
		assert_template 'devise/sessions/new'
		assert_not flash.empty?		
	end
	
	test "user that has no relation to a solution cannot see/edit/delete that problem" do
		sign_in_as(@user3)	
		get solution_path(@solution)
		follow_redirect!
		assert_not flash.empty?		
		assert_template 'static_pages/home'
		assert_match "You are not allowed to see this solution!!!" , response.body
		get edit_solution_path(@solution)
		follow_redirect!
		assert_template 'static_pages/home'
		assert_not flash.empty?			
	end
	
	test "once you have submitted a valid solution you can delete it and then still be able to upload a new one" do
		@solution.destroy
		sign_in_as(@user3)
		assert_difference 'Solution.count', 1 do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end  
   assert_redirected_to solution_path(@user3.solution_of(@problem).id)	
   
		
		get_custom_solution(get_custom_relation(@user1,@problem)) # trololo
   
    assert_difference 'Solution.count', -1 do
      delete solution_path(@user3.solution_of(@problem))
    end
    
   assert_difference 'Solution.count', 1 do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end  
   assert_redirected_to solution_path(@user3.solution_of(@problem).id)	
  end
  
  test "an atuthor of a problem who tries to create a solution with a different answer is redirected to edit proble" do
		sign_in_as(@user1)
		@solution_params[:answer]=0
		assert_no_difference 'Solution.count' do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end  
   assert_redirected_to edit_problem_path(@solution)
   assert_not flash.empty?
  end
  
  
  
end
