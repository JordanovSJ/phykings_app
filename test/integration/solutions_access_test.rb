require 'test_helper'
class SolutionsAccessTest< ActionDispatch::IntegrationTest

	def setup	
		@user1=users(:go6o) # creator of the problem
		@user2=users(:pe6o) #solver of the problem
		@user3=users(:stamat) #has not relation to the problem
		@problem=problems(:problem1_by_user1)
		@relation=get_custom_relation(@user2,@problem)
		@solution=get_custom_solution(@relation)
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
	
end
