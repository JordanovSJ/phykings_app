require 'test_helper'

class CapybaraCompetitionTest	< ActionDispatch::IntegrationTest
	include Warden::Test::Helpers
	Warden.test_mode!

	def setup
		@user2=users(:pe6o)
		@user1=users(:go6o)
		
	end


	test "1 player free competition" do
		sign_in_as(@user1)
		logout(@user1)
		get problem_path(1)
		assert_template 'problems/show', flash[:danger]
	end

end
