require 'test_helper'

class CapybaraCompetitionTest	< ActionDispatch::IntegrationTest
	include Capybara::DSL

	def setup
		@user2=users(:pe6o)
		@user1=users(:go6o)
		@params=get_params_for_competition
		problems1=@user1.uploaded_problems
		problems1.each do |p|
			get_custom_relation(@user1, p)
		end
		problems2=@user2.uploaded_problems
		problems2.each do |p|
			get_custom_relation(@user2, p)
		end
	end


	test "1 player free competition" do
		sign_in_as(@user2)
		@params[:n_players]=1
		@params[:entry_gold]=0
		@params[:target]=1
		@params[:length]=10
		post competitions_path, competition: @params
		follow_redirect!
		assert_template 'competitions/show'
		@user2.reload
		competition=Competition.find(@user2.competition_id)
		assert competition.started_at != nil
		problems=competition.problems
		problems.each do |p|
			assert p.target == 1
			assert @user2.relation_of(p).nil?
		end
		get problem_path(problems.first)
		assert_redirected_to competition_path(competition)
		assert_not flash.empty?
		solution1=get_custom_solution(problems.first.user_problem_relations.first)
		get solution_path(solution1)
		assert_redirected_to competition_path(competition)
		follow_redirect!
		assert_not flash.empty?
		assert_template 'competitions/show'
		assert_match "Players:", response.body
		assert_match "Length:", response.body
		assert_match "Weight:", response.body
		#capybara
		#find('answer_answer').set('some text')
		#fill_in 'answer_answer', :with => 3
		
		
	end
	
end
