require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest

	def setup
		@admin_user = users(:ivan)
		@user = users(:go6o)
  end

  test "should redirect home if not logged in" do
		get my_problems_users_path
		assert_redirected_to new_user_session_path
  end
   
  test "should redirect admin_users method if user not admin or moderator" do
		sign_in_as(@user)
		get admin_users_users_path
		assert_redirected_to root_path
  end
  
  test "should redirect admin_problems method if user not admin or moderator" do
		sign_in_as(@user)
		get admin_problems_users_path
		assert_redirected_to root_path
  end
  
  test "should redirect admin_solutions method if user not admin or moderator" do
		sign_in_as(@user)
		get admin_solutions_users_path
		assert_redirected_to root_path
  end
  
end
