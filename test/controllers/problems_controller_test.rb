require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase
	def setup	
		@user1=users(:go6o)
		@user2=users(:pe6o)
		@problem1=problems(:one)
	end

	#~ test "should redirect create when not logged in" do
    #~ assert_no_difference 'Problem.count' do
      #~ post :create, problem: { content: "neko + sa6o", title: "lubov", answer: 42 }
    #~ end
    #~ assert_redirected_to new_user_session_path
  #~ end
#~ 
  #~ test "should redirect destroy when not logged in" do
    #~ assert_no_difference 'Problem.count' do
      #~ delete :destroy, id: @problem1
    #~ end
    #~ assert_redirected_to new_user_session_path
  #~ end
  
  
end
