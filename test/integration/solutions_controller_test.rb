require 'test_helper'

class SolutionsControllersTest < ActionDispatch::IntegrationTest

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
	
	test "should not destroy when not signed in" do
    assert_no_difference 'Solution.count' do
      delete solution_path(@solution)
    end
    assert_redirected_to new_user_session_path
  end
  
  test "should not destroy when solutions doesnt belogns to you" do
    sign_in_as(@user1)
    assert_no_difference 'Solution.count' do
      delete solution_path(@solution)
    end
    assert_redirected_to root_path
    sign_in_as(@user3)
    assert_no_difference 'Solution.count' do
      delete solution_path(@solution)
    end
    assert_redirected_to root_path
  end

	test "should detroy when solution belongs to you" do
		sign_in_as(@user2)
    assert_difference 'Solution.count', -1 do
      delete solution_path(@solution)
    end
    assert_redirected_to root_path
	end
  
  		#CREATE action tests	
	test "should not create when not logged in" do
    assert_no_difference 'Solution.count' do
      post solutions_path, solution: @solution_params
    end
    assert_redirected_to new_user_session_path
  end
  
  test "should not create solution when user have no relation to a problem and the problem has a solutiono already" do
		sign_in_as(@user3)	
    assert_no_difference 'Solution.count' do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end
   assert_redirected_to root_path
  end
  
  test "should not create solution when u have already submitted solution" do
		sign_in_as(@user2)	
    assert_no_difference 'Solution.count' do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }				
    end
    assert_redirected_to "/solutions/#{@user2.solution_of(@problem).id}/edit?problem_id=#{@problem.id}" , flash[:danger]	

  end
  
  test "should create solution when problem has no solution" do 
		sign_in_as(@user3)
		@solution.destroy
		assert_difference 'Solution.count', 1 do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end  
   assert_redirected_to solution_path(@user3.solution_of(@problem).id)	
  end
  

  
  test "creator of a problem should be able to submit solution if havent done yet" do
    sign_in_as(@user1)	
   	assert_match "Signed in successfully." , response.body
    assert_difference 'Solution.count', 1 do
      post solutions_path, {solution: @solution_params, problem_id: @problem.id }						
    end
   assert_redirected_to solution_path(@user1.solution_of(@problem).id)
  end
  
  
  
  #edit/update
  test "authour of a solution can update solution" do
		sign_in_as(@user2)
		old_content=@solution.content
		patch solution_path(@solution), solution: {content: "Updated_content_of_custom_solution" }	
		assert_not old_content==@user2.solution_of(@problem).content			
  end
  
  
  test "someone who is not the author of a solution cannot update solution" do
		sign_in_as(@user1)
		old_content=@solution.content
		patch solution_path(@solution), solution: {content: "Updated_content_of_custom_solution" }	
		assert old_content==@user2.solution_of(@problem).content			
  end
end
