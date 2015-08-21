require 'test_helper'

class CompetitionsIntegrationTest	< ActionDispatch::IntegrationTest

	def setup
		@host=users(:go6o)
		@player2=users(:pe6o)
		@player3=users(:stamat)
		@params=get_params_for_competition
		@competition=get_custom_competition
	end

	test "cannot create competition if already in competition" do
		sign_in_as(@host)
		assert_difference 'Competition.count', 1 do
			post competitions_path, competition: @params
		end	
		assert_no_difference 'Competition.count' do
			post competitions_path, competition: @params
		end
	end

	test "cannot join competition if already in competition" do
		sign_in_as(@host)
		get competition_path(@competition)
		@host.reload
		assert @host.competition_id==@competition.id
		@competition2=get_custom_competition
		get competition_path(@competition2)
		assert_redirected_to competition_path(@competition)
		assert_not flash.empty?
	end

	test "cannot join full competition" do
		@host.update_attributes!(competition_id: @competition.id)
		@player2.update_attributes!(competition_id: @competition.id)
		sign_in_as(@player3)
		get competition_path(@competition)
		follow_redirect!
		assert_template 'competitions/index', flash[:danger]
		assert_not flash.empty?
	end
	
	
end
