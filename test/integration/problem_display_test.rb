require 'test_helper'

class ProblemDisplayTest	< ActionDispatch::IntegrationTest
	
	def setup
		@problem=problems(:two)
	end
	
	#~ test "display problem" do
		#~ log_in_as(users(:pe6o))
		#~ 
		#~ get problem_path(@problem)
		#~ assert_template 'problems/show'
		#~ assert_match @problem.title, response.body
		#~ assert_match @problem.content, response.body
		#~ assert_match "#{@problem.answer}", response.body
	#~ end
	
	test "signed_out user cannot access problems" do
		get new_problem_path(@problem)
		#assert_template 'devise/sessions/new'
		assert_not flash.empty?
		get problem_path(@problem)
		#assert_template 'devise/sessions/new'
		assert_not flash.empty?
		get edit_problem_path(@problem)
		#assert_template 'devise/sessions/new'
		assert_not flash.empty?		
	end
	
end
