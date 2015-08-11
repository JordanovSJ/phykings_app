require 'test_helper'

class ProblemDisplayTest	< ActionDispatch::IntegrationTest
	
	def setup
		@problem=problems(:one)
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
	
	test "user that has no relation to a problem cannot see/edit/delete that problem" do
		sign_in_as(@user)	
		get problem_path(problems(:two))
		follow_redirect!
		assert_template 'static_pages/home'
		assert_not flash.empty?
		get edit_problem_path(problems(:two))
		follow_redirect!
		assert_template 'static_pages/home'
		assert_not flash.empty?			
	end
	

end
