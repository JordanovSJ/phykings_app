require 'test_helper'

class SolutionsIntegrationsTest < ActionDispatch::IntegrationTest

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
end
