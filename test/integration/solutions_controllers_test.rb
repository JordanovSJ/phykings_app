require 'test_helper'

class SolutionsControllersTest < ActionDispatch::IntegrationTest

	#~ def setup	
		#~ @user1=users(:go6o)
		#~ @user2=users(:pe6o)
		#~ @user3=users(:ivan)
		#~ @problem=problems(:problem1_by_user1)
		#~ @relation=get_custom_relation(@user2,@problem)
		#~ @solution=get_custom_solution(@relation)
	#~ end
	
	
	#~ test "signed_out user cannot access solutions" do
		#~ get new_solution_path
		#~ follow_redirect!
		#~ assert_template 'devise/sessions/new'
		#~ assert_not flash.empty?
		#~ get solution_path(@solution)
		#~ follow_redirect!
		#~ assert_template 'devise/sessions/new'
		#~ assert_not flash.empty?
		#~ get edit_solution_path(@solution)
		#~ follow_redirect!
		#~ assert_template 'devise/sessions/new'
		#~ assert_not flash.empty?		
	#~ end
end
