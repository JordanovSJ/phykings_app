require 'test_helper'

class CompetitionsControllersTest	< ActionDispatch::IntegrationTest
	def setup
		@host=users(:go6o)
		@params=get_params_for_competition
	end
	
	test "cannot create competition if not signed in" do
		assert_no_difference 'Competition.count' do
			post competitions_path, competition: @params
		end
	end
	
	
	test "should create competition when logged in" do
		sign_in_as(@host)
		assert_difference 'Competition.count', 1 do
			post competitions_path, competition: @params
		end
	end
end
