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
	
	#gold
	
	test "user with unsufficient gold cannot create a competition" do
		sign_in_as(@host)
		@params[:entry_gold]=10
		assert_no_difference 'Competition.count' do
			post competitions_path, competition: @params
		end	
		assert_redirected_to competitions_path
		assert_not flash.empty?
	end
	
	
	test "user with sufficient gold can create a competition" do
		sign_in_as(@host)
		Bank.access.update_attributes!(total_gold: 1000)
		@host.update_attributes!(gold: 20)
		@params[:entry_gold]=10
		assert Bank.access.present_gold==0
		assert @host.gold==20
		assert_difference 'Competition.count', 1 do
			post competitions_path, competition: @params
		end	
		@host.reload
		assert_redirected_to competition_path(@host.competition_id)
		assert_not flash.empty?
		assert Bank.access.present_gold==10 , Bank.access.present_gold.to_s
		assert @host.gold==10 , @host.gold.to_s
	end
	
	test "uset that doesnt have enough gold cannot join competition" do
		@competition.update_attributes!(entry_gold: 10)
		sign_in_as(@player2)
		get competition_path(@competition)
		assert_redirected_to competitions_path
		assert_not flash.empty?
	end	
	
	test "uset that  have enough gold can join competition" do
		@competition.update_attributes!(entry_gold: 10)
		sign_in_as(@player2)
		Bank.access.update_attributes!(total_gold: 1000)
		@player2.update_attributes!(gold: 10000)
		assert @player2.gold==10000
		assert Bank.access.present_gold==0
		get competition_path(@competition)
		assert Bank.access.present_gold==10
		@player2.reload
		assert @player2.gold==9990
		assert_template 'competitions/show'
	end	
	
	
	test "problems percent sum must be 100" do
		Problem.delete_all
		problem1=get_custom_problem(@player2)
		problem1.length=30
		problem1.difficulty=3
		problem1.save!
		problem2=get_custom_problem(@player2)
		problem2.length=30
		problem2.difficulty=9
		problem2.save!
		sign_in_as(@host)
		problem3=get_custom_problem(@host)
		problem3.length=30
		problem3.difficulty=5
		problem3.save!
		get_custom_relation(@host, problem3)
		sign_in_as(@host)
		@params[:n_players]=1
		@params[:length]=60
		post competitions_path, competition: @params
		follow_redirect!
		@host.reload
		competition=Competition.find(@host.competition_id)
		assert Problem.count==3, Problem.count
		assert competition.problems.count==2 , competition.problems.count
		assert_not competition.problems.include?(problem3)
		sum=competition.problems_percents["percent_problem_#{problem1.id}"] + competition.problems_percents["percent_problem_#{problem2.id}"]
		assert sum==100
	end
	
	#~ test "User relations after competition " do
		#~ sign_in_as(@host)
		#~ post competitions_path, competition: @params
	#~ end
end
